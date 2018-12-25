using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter),typeof(MeshRenderer))]

public class PlaneMesh : MonoBehaviour
{
    Mesh m_mesh;
    Vector3 []m_verticePos;
    int[] m_tris;
    void Start()
    {
        m_mesh = new Mesh();
        // init vertices 
        m_verticePos = new Vector3[4] {
            new Vector3(-0.5f,-0.5f),
            new Vector3(0.5f,-0.5f),
            new Vector3(0.5f,0.5f),
            new Vector3(-0.5f,0.5f),
        };

        // init tris
        m_tris = new int[] { 0,1,2 };


        m_mesh.vertices = m_verticePos;
        m_mesh.triangles = m_tris;
        GetComponent<MeshFilter>().mesh = m_mesh;
    }

    void Update()
    {
        
    }

    private void OnDrawGizmos()
    {
        if(m_verticePos!=null)
        {
            foreach(var vertexPos in m_verticePos)
            {
                Gizmos.DrawSphere( transform.TransformPoint(vertexPos), 0.2f);
            }
        }
    }

}
