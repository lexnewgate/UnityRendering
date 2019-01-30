Shader "MyShaders/Basic/Ambient" 
{
    Properties
    {
    }

    SubShader
    {
        pass
        {
            CGPROGRAM
            struct a2v
            {
                float4 pos:POSITION;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
            };
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(a2v i)
            {
                v2f o;
                o.pos= UnityObjectToClipPos(i.pos);
                return o;
            }

            fixed4 frag():SV_TARGET
            {
                return UNITY_LIGHTMODEL_AMBIENT;
            }

            ENDCG
        }
    }
}