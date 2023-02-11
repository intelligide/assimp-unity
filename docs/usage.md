---
layout: default
title: Usage
nav_order: 3
---

# {{ page.title }}
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

*WIP*

{: .warning }
Assimp for Unity is based on [AssimpNet](https://bitbucket.org/Starnick/assimpnet/). This project does not offer full support for AssimpNet and we will never offer it. This page is therefore incomplete and serves as a starting point for using AssimpNet. We encourage you to read official [AssimpNet](https://bitbucket.org/Starnick/assimpnet/) Documentation.

All AssimpNet classes are located on `Assimp` namespace:
```
using Assimp;
```

## Importation

You must create
```c#
AssimpContext importer = new AssimpContext();
```

### Create Assimp Scene from files

```c#
Scene scene = importer.ImportFile("mymodel.fbx");
```

```c#
Scene scene = importer.ImportFile("mymodel.fbx", PostProcessSteps.CalculateTangentSpace | PostProcessSteps.GenerateNormals);
```

Yon can also use presets:

```c#
Scene scene = importer.ImportFile("mymodel.fbx", PostProcessPreset.ConvertToLeftHanded);
```
```c#
Scene scene = importer.ImportFile("mymodel.fbx", PostProcessPreset.TargetRealTimeQuality);
```

```c#
Scene scene = importer.ImportFile("mymodel.fbx", PostProcessPreset.TargetRealTimeMaximumQuality);
```

### Create Assimp Scene from streams

```c#
Stream stream = File.Open("mymodel.fbx", FileMode.Open);
Scene scene = importer.ImportFileFromStream(stream);
```

{: .note }
You can also pass PostProcessSteps options in the second parameter.

{: .warning }
Assimp will try to detect what importer to use from the data which may or may not be successful. You can pass optional format extension as last parameter to serve as a hint to Assimp to choose which importer to use

### Access Scene components

#### Meshes

```c#
foreach(Mesh m in scene.Meshes)
{
    List<Vector3D> verts = m.Vertices;
    List<Vector3D> norms = (m.HasNormals) ? m.Normals : null;
    List<Vector3D> uvs = m.HasTextureCoords(0) ? m.TextureCoordinateChannels[0] : null;

    for(int i = 0; i < verts.Count; i++)
    {
        Vector3D pos = verts[i];
        Vector3D norm = (norms != null) ? norms[i] : new Vector3D(0, 0, 0);
        Vector3D uv = (uvs != null) ? uvs[i] : new Vector3D(0, 0, 0);

        ...
    }

    List<Face> faces = m.Faces;

    ...
}
```


#### Materials

```c#
foreach(Material m in scene.Materials)
{
    Color4D diffuseColor = new Color4D(1, 1, 1, 1);
    if(m.HasColorDiffuse)
    {
        diffuseColor = m.ColorDiffuse;
    }

    String diffuseFilePath = String.Empty;
    if(m.HasTextureDiffuse)
    {
        filePath = Path.Combine(baseDir, m.TextureDiffuse.FilePath);
    }

    ...
}
```

#### ... and others

AssimpNet API is very similar to the C++ Assimp API. You can check
[Assimp Docs](https://assimp-docs.readthedocs.io/en/latest/) in order to use this.

## Export

### Exporting to files

***WIP***

### Exporting to blob

***WIP***

## Advanced parameters

### Scaling the scene

```c#
importer.Scale = 3;
```

### Rotating the scene

```c#
importer.XAxisRotation = 3;
importer.YAxisRotation = 3;
importer.ZAxisRotation = 3;
```
