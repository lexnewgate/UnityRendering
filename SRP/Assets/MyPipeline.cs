using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;

public class MyPipeline : RenderPipeline
{
    public override void Render(ScriptableRenderContext renderContext, Camera[] cameras)
    {
        base.Render(renderContext, cameras);
        foreach(var camera in cameras)
        {
            Render(renderContext, camera);
        }
    }

    void Render(ScriptableRenderContext renderContext ,Camera camera)
    {
        renderContext.SetupCameraProperties(camera);//Setup camera specific global shader variables.
        renderContext.DrawSkybox(camera);

        var commandBuf = new CommandBuffer {  name="Camera"};
        var cameraClearFlags = camera.clearFlags;
        commandBuf.ClearRenderTarget((cameraClearFlags&CameraClearFlags.Depth)!=0, 
                                     (cameraClearFlags&CameraClearFlags.Color)!=0, 
                                     camera.backgroundColor);
        renderContext.ExecuteCommandBuffer(commandBuf);
        commandBuf.Release();

        renderContext.Submit();
    }
}
