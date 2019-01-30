using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]

public class PlaneMesh : MonoBehaviour
{
    Mesh m_mesh;
    public int m, n;
    public Vector4 testTanget;

    int m_vertexCount;
    int m_triCount;
    Vector3[] m_verticePos;
    int[] m_tris;
    Vector3[] m_normals;
    Vector4[] m_tangents;
    Vector2[] m_uvs;

    void InitVertices()
    {
        m_verticePos = new Vector3[this.m_vertexCount];
        Vector3 verticeInitTranslate = new Vector3(-(float)n / 2, 0, -(float)m / 2);
        for (int i = 0; i <= m; i++)
        {
            for (int j = 0; j <= n; j++)
            {
                m_verticePos[i * (n + 1) + j] = new Vector3(j, 0, i) + verticeInitTranslate;
            }
        }
    }

    void InitTris()
    {
        this.m_tris = new int[this.m_triCount * 3];

        for (int j = 1; j <= m; j++)
        {
            var triVertBase = (n + 1) * (j - 1);
            var triIndexBase = 6 * n * (j - 1);
            for (int i = 1; i <= n; i++)
            {
                this.m_tris[triIndexBase + 6 * (i - 1)] = i - 1 + triVertBase;
                this.m_tris[triIndexBase + 6 * (i - 1) + 1] = i + n + triVertBase;
                this.m_tris[triIndexBase + 6 * (i - 1) + 2] = i + triVertBase;

                this.m_tris[triIndexBase + 6 * (i - 1) + 3] = i + triVertBase;
                this.m_tris[triIndexBase + 6 * (i - 1) + 4] = i + n + triVertBase;
                this.m_tris[triIndexBase + 6 * (i - 1) + 5] = i + n + 1 + triVertBase;
            }
        }
    }

    void InitNormals()
    {
        this.m_normals = new Vector3[this.m_vertexCount];
        for(int i=0;i<this.m_vertexCount;i++)
        {
            this.m_normals[i] = Vector3.up;
        }
    }

    void InitUVs()
    {
        this.m_uvs = new Vector2[this.m_vertexCount];
        for(int i=0;i<=m;i++)
        {
            for(int j=0;j<=n;j++)
            {
                this.m_uvs[i * (n + 1) + j] = new Vector2(1-(float)j / n,1- (float)i / m);
            }
        }
    }

    void InitTangents()
    {
        this.m_tangents = new Vector4[this.m_vertexCount];
        for(int i=0;i<this.m_vertexCount;i++)
        {
            this.m_tangents[i] = testTanget;
        }
    }

    void Start()
    {
        m_mesh = new Mesh();
        m_vertexCount = (m + 1) * (n + 1);
        m_triCount = m * n * 2;

        InitVertices();
        InitTris();
        InitNormals();
        InitUVs();

      
    }

    void Update()
    {

        InitTangents();
        m_mesh.vertices = m_verticePos;
        m_mesh.triangles = m_tris;
        m_mesh.normals = m_normals;
        m_mesh.tangents = m_tangents;
        m_mesh.uv = m_uvs;

        GetComponent<MeshFilter>().mesh = m_mesh;
    }

    private void OnDrawGizmos()
    {
        if (m_verticePos != null)
        {
            foreach (var vertexPos in m_verticePos)
            {
                Gizmos.DrawSphere(transform.TransformPoint(vertexPos), 0.2f);
            }
        }
    }

}
