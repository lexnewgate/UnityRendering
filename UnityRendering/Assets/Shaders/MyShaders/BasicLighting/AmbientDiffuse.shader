Shader "MyShaders/Basic/AmbientDiffuse" 
{
    Properties
    {
        _diffusek("Diffuse",float)=1
    }

    SubShader
    {
        pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            float4 _MainColor;
            fixed _diffusek;
            struct a2v
            {
                float4 pos:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 color:COLOR;
            };
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(a2v i)
            {
                v2f o;
                o.pos= UnityObjectToClipPos(i.pos);

                fixed4 ambient=UNITY_LIGHTMODEL_AMBIENT;
                fixed4 lightColor=_LightColor0 ;
                float3 N= normalize(UnityObjectToWorldDir(i.normal));
                float3 L= normalize(_WorldSpaceLightPos0.xyz);

                //calculate diffuse in worldspace
                fixed4 diffuse= saturate (dot(N,L)) *_diffusek*lightColor;

                o.color=ambient+diffuse;

                return o;
            }

            fixed4 frag(v2f i):SV_TARGET
            {
                return i.color;
            }

            ENDCG
        }
    }
}