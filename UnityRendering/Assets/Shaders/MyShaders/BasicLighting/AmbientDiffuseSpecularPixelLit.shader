Shader "MyShaders/Basic/AmbientDiffuseSpecularPixelLit" 
{
    Properties
    {
        _diffusek("Diffuse",float)=1
        _speculark("Specular",float)=1
        _gloss("Gloss",float)=1
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
            fixed _speculark;
            float _gloss;
            struct a2v
            {
                float4 pos:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 objectPos:TEXCOORD0;
                float4 pos:SV_POSITION;
                float3 worldNormal:NORMAL;
            };
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(a2v i)
            {
                v2f o;
                o.pos= UnityObjectToClipPos(i.pos);
                o.objectPos=i.pos;
                o.worldNormal=normalize(UnityObjectToWorldDir(i.normal));

                return o;
            }

            fixed4 frag(v2f i):SV_TARGET
            {
                //1. ambient
                fixed4 ambient=UNITY_LIGHTMODEL_AMBIENT;

                //2. diffuse
                fixed4 lightColor=_LightColor0 ;
                float3 L= normalize(_WorldSpaceLightPos0.xyz);

                //calculate diffuse in worldspace
                fixed4 diffuse= saturate (dot(i.worldNormal,L)) *_diffusek*lightColor;

                //3. specular
                // first rdir=2(ndir dot ldir)*ndir-ldir
                // second rdir approximation = hdir=(vdir+ldir)/ mag(vdir+ldir)
                // specular= c_light* max(0,vdir dot rdir)^gloss
                fixed3 rdir= normalize(reflect(-L,i.worldNormal));
                fixed3 vdir =normalize( _WorldSpaceCameraPos- mul(UNITY_MATRIX_M,i.objectPos));

                fixed4 specular= _speculark*lightColor* pow(saturate(dot(rdir,vdir)),_gloss)  ;


                fixed4 final =ambient+diffuse+specular;
                return final;
            }

            ENDCG
        }
    }
}