Shader "MyShaders/Basic/AmbientDiffuseSpecularVertLit" 
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
                float4 pos:SV_POSITION;
                fixed4 color:COLOR;
            };
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(a2v i)
            {
                v2f o;
                o.pos= UnityObjectToClipPos(i.pos);
                //1. ambient
                fixed4 ambient=UNITY_LIGHTMODEL_AMBIENT;

                //2. diffuse
                fixed4 lightColor=_LightColor0 ;
                float3 N= normalize(UnityObjectToWorldDir(i.normal));
                float3 L= normalize(_WorldSpaceLightPos0.xyz);

                //calculate diffuse in worldspace
                fixed4 diffuse= saturate (dot(N,L)) *_diffusek*lightColor;

                //3. specular
                // first rdir=2(ndir dot ldir)*ndir-ldir
                // second rdir approximation = hdir=(vdir+ldir)/ mag(vdir+ldir)
                // specular= c_light* max(0,vdir dot rdir)^gloss
                fixed3 rdir= normalize(reflect(-L,N));
                fixed3 vdir =normalize( _WorldSpaceCameraPos- mul(UNITY_MATRIX_M,i.pos));

                fixed4 specular= _speculark*lightColor* pow(saturate(dot(rdir,vdir)),_gloss)  ;


                o.color=ambient+diffuse+specular;

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