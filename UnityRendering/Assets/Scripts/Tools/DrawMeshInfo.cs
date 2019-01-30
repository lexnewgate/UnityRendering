using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class DrawMeshInfo : MonoBehaviour
{
    public Color normalColor = Color.blue;
    public Color tangentColor = Color.red;
    public Color textColor = Color.green;

    public bool isShowNormal = false;
    public bool isShowTanget = false;
    public bool isShowTextInfo = true;
    public float textYOffSet = 10;
    public int textFontSize=7;
    public bool showRenderingInfo = false;
    public bool showMeshInfo = false;



    private void OnDrawGizmos()
    {
        GizmosDrawNormalTangent();
        ShowTextInfo();
    }

    void ShowTextInfo()
    {
        if (!isShowTextInfo)
            return;
        GUIStyle guiStyle = new GUIStyle();
        guiStyle.normal.textColor = textColor;
        guiStyle.alignment=TextAnchor.MiddleCenter;
        guiStyle.fontSize=textFontSize;
        

        var goName = this.name;
        var mat = this.GetComponent<MeshRenderer>().sharedMaterial;
        var mesh = this.GetComponent<MeshFilter>().sharedMesh;
        if (mat == null || mesh == null)
            return;

        var triCount = mesh.triangles.Length / 3;
        var vertCount = mesh.vertexCount;

        List<string> textInfos = new List<string>();
        textInfos.Add($"{goName}\n");
        if (showRenderingInfo)
        {
            var matName = mat.name;
            var shaderName = mat.shader.name;
            textInfos.Add($"mat:{matName}\nshader:{shaderName}\n");
        }

        if (showMeshInfo)
        {
            textInfos.Add($"tri:{triCount} vert:{vertCount}");
        }

        var graphicDesc=string.Join("",textInfos);
        Handles.Label(this.transform.position + Vector3.up * textYOffSet, graphicDesc, guiStyle);
    }


    void GizmosDrawNormals(Mesh mesh)
    {
        if (!isShowNormal)
            return;
        if (mesh == null)
            return;
        Gizmos.color = normalColor;
        if (mesh.normals != null)
        {
            for (int i = 0; i < mesh.normals.Length; i++)
            {
                var vertexPos = mesh.vertices[i];
                var worldPos = this.transform.TransformPoint(vertexPos);
                var localNormal = mesh.normals[i];
                var worldNormal = this.transform.TransformDirection(localNormal).normalized;


                Gizmos.DrawRay(worldPos, worldNormal);
            }
        }
    }

    void GizmosDrawTangents(Mesh mesh)
    {
        if (!isShowTanget)
            return;
        if (mesh == null)
            return;
        Gizmos.color = tangentColor;
        if (mesh.tangents != null)
        {
            for (int i = 0; i < mesh.tangents.Length; i++)
            {
                var vertexPos = mesh.vertices[i];
                var worldPos = this.transform.TransformPoint(vertexPos);
                var localTanget = mesh.tangents[i];
                var worldTanget = this.transform.TransformDirection(localTanget);
                Gizmos.DrawRay(worldPos, worldTanget);
            }
        }
    }

    void GizmosDrawNormalTangent()
    {
        var meshFilter = GetComponent<MeshFilter>();
        var mesh = meshFilter?.sharedMesh;
        if (mesh)
        {
            GizmosDrawNormals(mesh);
            GizmosDrawTangents(mesh);

        }
    }
}
