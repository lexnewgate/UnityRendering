using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Grid : MonoBehaviour {

    int m_xSize, m_ySize;
    Vector3 []m_vertices;
    private void Awake()
    {
        Generate();
    }

    void Start () {
	
	}
	
	void Update () {
		
	}

    void Generate()
    {
        m_vertices = new Vector3[(m_xSize + 1)*(m_ySize + 1)];
    }

    private void OnDrawGizmos()
    {
        if(m_vertices==null)
        {
            return;
        }
        Gizmos.color = Color.black;
        foreach(var vertex in m_vertices)
        {
            Gizmos.DrawSphere(vertex, .2f);
        }
        
    }

}
