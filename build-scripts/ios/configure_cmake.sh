
###################################
# 		 SDK Version
###################################
IOS_SDK_VERSION=$(xcodebuild -version -sdk iphoneos | grep SDKVersion | cut -f2 -d ':' | tr -d '[[:space:]]')
###################################

###################################
# 		 BUILD Configuration
###################################

BUILD_SHARED_LIBS=OFF
BUILD_TYPE=Release

################################################
# 		 Minimum iOS deployment target version
################################################
MIN_IOS_VERSION="6.0"

IOS_SDK_TARGET=$MIN_IOS_VERSION
XCODE_ROOT_DIR=$(xcode-select  --print-path)
TOOLCHAIN=$XCODE_ROOT_DIR/Toolchains/XcodeDefault.xctoolchain

CMAKE_C_COMPILER=$(xcrun -find cc)
CMAKE_CXX_COMPILER=$(xcrun -find c++)

BUILD_ARCHS_DEVICE="arm64e arm64 armv7s armv7"
BUILD_ARCHS_SIMULATOR="x86_64 i386"
BUILD_ARCHS_ALL=($BUILD_ARCHS_DEVICE $BUILD_ARCHS_SIMULATOR)

CPP_DEV_TARGET_LIST=(miphoneos-version-min mios-simulator-version-min)
CPP_DEV_TARGET=
CPP_STD_LIB_LIST=(libc++ libstdc++)
CPP_STD_LIB=libc++
CPP_STD_LIST=(c++11 c++14)
CPP_STD=c++11

SOURCE_DIRECTORY="."
BUILD_DIRECTORY="."

ARCH_TARGET=

function join { local IFS="$1"; shift; echo "$*"; }

configure_cmake()
{
    IOS_SDK_DEVICE=iPhoneOS
    CPP_DEV_TARGET=${CPP_DEV_TARGET_LIST[0]}

    if [[ "$BUILD_ARCHS_SIMULATOR" =~ "$1" ]]
    then
        echo '[!] Target SDK set to SIMULATOR.'
        IOS_SDK_DEVICE=iPhoneSimulator
        CPP_DEV_TARGET=${CPP_DEV_TARGET_LIST[1]}
    else
        echo '[!] Target SDK set to DEVICE.'
    fi

    unset DEVROOT SDKROOT CFLAGS LDFLAGS CPPFLAGS CXXFLAGS CMAKE_CLI_INPUT

    export DEVROOT=$XCODE_ROOT_DIR/Platforms/$IOS_SDK_DEVICE.platform/Developer
    export SDKROOT=$DEVROOT/SDKs/$IOS_SDK_DEVICE$IOS_SDK_VERSION.sdk
    export EXTRAFLAGS="-arch $1 -pipe -no-cpp-precomp -stdlib=$CPP_STD_LIB -isysroot $SDKROOT -I$SDKROOT/usr/include/ -miphoneos-version-min=$IOS_SDK_TARGET"
    if [[ "$BUILD_TYPE" =~ "Debug" ]]; then
        export EXTRAFLAGS="$EXTRAFLAGS -Og"
    else
	    export EXTRAFLAGS="$EXTRAFLAGS -O3"
    fi
    export LDFLAGS="$LDFLAGS -arch $1 -isysroot $SDKROOT -L$SDKROOT/usr/lib/"
    export CFLAGS="$CFLAGS $EXTRAFLAGS"
    export CPPFLAGS="$CPPFLAGS $EXTRAFLAGS"
    export CXXFLAGS="$CXXFLAGS $EXTRAFLAGS -std=$CPP_STD"

    CMAKE_CLI_INPUT="-S $SOURCE_DIRECTORY -B $BUILD_DIRECTORY -DCMAKE_C_COMPILER=$CMAKE_C_COMPILER -DCMAKE_CXX_COMPILER=$CMAKE_CXX_COMPILER
        -DCMAKE_TOOLCHAIN_FILE=$SOURCE_DIRECTORY/port/iOS/IPHONEOS_$(echo $1 | tr '[:lower:]' '[:upper:]')_TOOLCHAIN.cmake
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS"

    echo "[!] Configuring CMake for $1 with -G 'Unix Makefiles' $CMAKE_CLI_INPUT"

    cmake -G 'Unix Makefiles' ${CMAKE_CLI_INPUT}
}

# Main

echo "[!] $0 - assimp iOS build script"

for i in "$@"; do
    case $i in
    -S=*|--source-directory=*)
        SOURCE_DIRECTORY=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        echo "[!] Source directory: $SOURCE_DIRECTORY"
    ;;
    -B=*|--build-directory=*)
        BUILD_DIRECTORY=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        echo "[!] Build directory: $BUILD_DIRECTORY"
    ;;
    -s=*|--std=*)
        CPP_STD=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        echo "[!] Selecting c++ standard: $CPP_STD"
    ;;
    -l=*|--stdlib=*)
        CPP_STD_LIB=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        echo "[!] Selecting c++ std lib: $CPP_STD_LIB"
    ;;
    -a=*|--arch=*)
        ARCH_TARGET=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        echo "[!] Selecting architecture: $ARCH_TARGET"
    ;;
    --debug)
    	BUILD_TYPE=Debug
        echo "[!] Selecting build type: Debug"
    ;;
    --shared-lib)
    	BUILD_SHARED_LIBS=ON
        echo "[!] Will generate dynamic libraries"
    ;;
    -h|--help)
        echo " - Include debug information and symbols, no compiler optimizations (--debug)."
        echo " - generate dynamic libraries rather than static ones (--shared-lib)."
        echo " - supported architectures (--arch):  $(echo $(join , ${BUILD_ARCHS_ALL[*]}) | sed 's/,/, /g')"
        echo " - supported C++ STD libs (--stdlib): $(echo $(join , ${CPP_STD_LIB_LIST[*]}) | sed 's/,/, /g')"
        echo " - supported C++ standards (--std): $(echo $(join , ${CPP_STD_LIST[*]}) | sed 's/,/, /g')"
        exit
    ;;
    *)
    ;;
    esac
done

if [ -z "$ARCH_TARGET" ]
then
    echo "Missing architecture argument"
    exit 1
else
    configure_cmake $ARCH_TARGET
fi
