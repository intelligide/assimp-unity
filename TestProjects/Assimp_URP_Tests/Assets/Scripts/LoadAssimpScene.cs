using System.Collections;
using System.Collections.Generic;
using System.IO;
using Assimp;
using UnityEngine;
using UnityEngine.Networking;

public class LoadAssimpScene : MonoBehaviour
{
    public MeshFilter MeshTemplate;

    void Start()
    {
        AssimpContext importer = new AssimpContext();

        #if UNITY_ANDROID
        var loadingRequest = UnityWebRequest.Get(Path.Combine(Application.streamingAssetsPath, "Model.fbx"));
        loadingRequest.SendWebRequest();

        while (!loadingRequest.isDone)
        {
            if (loadingRequest.result == UnityWebRequest.Result.ConnectionError || loadingRequest.result == UnityWebRequest.Result.ProtocolError)
            {
                break;
            }
        }

        if (loadingRequest.result == UnityWebRequest.Result.ConnectionError || loadingRequest.result == UnityWebRequest.Result.ProtocolError)
        {
            return;
        }

        MemoryStream fileStream = new MemoryStream(loadingRequest.downloadHandler.data);
        #else
        var fileStream = File.OpenRead(Path.Combine(Application.streamingAssetsPath, "Model.fbx"));
        #endif

        Scene scene = importer.ImportFileFromStream(fileStream, PostProcessSteps.Triangulate |
                                                        PostProcessSteps.CalculateTangentSpace |
                                                        PostProcessSteps.OptimizeMeshes |
                                                        PostProcessSteps.MakeLeftHanded);

        if(scene is not null && scene.HasMeshes)
        {
            foreach(Assimp.Mesh importedMesh in scene.Meshes)
            {
                var mesh = new UnityEngine.Mesh();

                List<Vector3> vertices = new(importedMesh.Vertices.Count);
                foreach(Vector3D vertex in importedMesh.Vertices)
                {
                    vertices.Add(new Vector3(vertex.X, vertex.Y, vertex.Z));
                }
                mesh.vertices = vertices.ToArray();

                List<int> triangles = new();
                foreach(Assimp.Face face in importedMesh.Faces)
                {
                    face.Indices.Reverse();
                    triangles.AddRange(face.Indices);
                }
                mesh.triangles = triangles.ToArray();

                List<Vector3> normals = new(importedMesh.Normals.Count);
                foreach(Vector3D vertex in importedMesh.Normals)
                {
                    normals.Add(new Vector3(vertex.X, vertex.Y, vertex.Z));
                }
                mesh.normals = normals.ToArray();

                List<Vector4> tangents = new(importedMesh.Tangents.Count);
                foreach(Vector3D tangent in importedMesh.Tangents)
                {
                    tangents.Add(new Vector4(tangent.X, tangent.Y, tangent.Z, 1));
                }
                mesh.tangents = tangents.ToArray();

                if(importedMesh.HasTextureCoords(0))
                {
                    List<Vector2> uv = new();
                    foreach(Assimp.Vector3D tan in importedMesh.TextureCoordinateChannels[0])
                    {
                        uv.Add(new Vector2(tan.X, tan.Y));
                    }
                    mesh.uv = uv.ToArray();
                }

                mesh.RecalculateBounds();

                var meshFilter = Instantiate(MeshTemplate, new Vector3(0, 0, 0), UnityEngine.Quaternion.identity);
                meshFilter.mesh = mesh;
            }
        }
    }
}
