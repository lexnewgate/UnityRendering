Shader "Block/OpaqueTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("周围", 2D) = "white" {}
        _TopTex ("顶部", 2D) = "white" {}
        _BotTex ("底部", 2D) = "white" {}

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _TopTex;
        sampler2D _BotTex;


        struct Input
        {
            float2 uv_MainTex;

        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		//1:sur 2:top 3:bot

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)


			void vert(inout appdata_full v) {
			//UNITY_INITIALIZE_OUTPUT(Input, data);
			float3 worldSpace = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldScale = float3(
				length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
				length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
				length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
				);

			worldScale = worldScale * v.vertex;
			float3 n = normalize(mul(unity_ObjectToWorld, v.normal).xyz);

			if ((n.x==0&&n.z==0)&&(n.y==1||n.y==-1))
			{

				v.texcoord.xy = worldScale.xz;
			
			}

			else
			{
			
			// Get the closest vector in the polygon's plane to world up.
			// We'll use this as the "v" direction of our texture.
			float3 vDirection = normalize(float3(0, 1, 0) - n.y * n);
			

			// Get the perpendicular in-plane vector to use as our "u" direction.
			float3 uDirection = normalize(cross(n, vDirection));
		

			// Get the position of the vertex in worldspace.

			// Project the worldspace position of the vertex into our texturing plane,
			// and use this result as the primary texture coordinate.
			v.texcoord.xy = float2(dot(worldScale, uDirection), dot(worldScale, vDirection));

			}

		}


        void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c;
			if (o.Normal.y>0.99999)
			{
				c= tex2D (_TopTex, IN.uv_MainTex) * _Color;
			}
			else if (o.Normal.y<-0.99999)
			{
				c = tex2D(_BotTex, IN.uv_MainTex)*_Color;
			}
			else 
			{
				c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
			}

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
