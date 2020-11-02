﻿using UnityEngine;

namespace retro_camera
{
    [ExecuteInEditMode]
    public class CameraPostProcessEffect : MonoBehaviour
    {
        [SerializeField] protected Material material = null;

        void OnRenderImage (RenderTexture source, RenderTexture destination)
        {
            preRenderImage (source, destination);

            if (material != null)
            {
                Graphics.Blit (source, destination, material);
            }
            else
            {
                Graphics.Blit (source, destination);
            }
        }

        protected virtual void preRenderImage (RenderTexture source, RenderTexture destination) { }
    }
}


