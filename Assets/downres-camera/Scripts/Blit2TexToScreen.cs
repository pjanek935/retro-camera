using UnityEngine;

namespace retro_camera
{
    [ExecuteInEditMode]
    public class Blit2TexToScreen : MonoBehaviour
    {
        [SerializeField] int downscaleFactor = 0;
        [SerializeField] Material material = null;
        [SerializeField] DownresCamera frontCamera;
        [SerializeField] DownresCamera backCamera;

        private int oldScreenWidth;
        private int oldScreenHeight;
        private int oldDownscaleFactor;

        public int RenderTextureWidth
        {
            get;
            private set;
        }

        public int RenderTextureHeight
        {
            get;
            private set;
        }

        private void Start ()
        {
            refreshVariables ();
            refreshTargetTextures ();
            setRenderTextures ();
        }

        private void OnValidate ()
        {
            if (downscaleFactor < 0)
            {
                downscaleFactor = 0;
            }

            refreshVariables ();
            refreshTargetTextures ();
            setRenderTextures ();
        }

        void refreshTargetTextures ()
        {
            if (frontCamera != null)
            {
                frontCamera.RefreshTargetTexture (RenderTextureWidth, RenderTextureHeight, 24);
            }

            if (backCamera != null)
            {
                backCamera.RefreshTargetTexture (RenderTextureWidth, RenderTextureHeight, 24);
            }
        }

        void setRenderTextures ()
        {
            if (material != null)
            {
                if (frontCamera != null)
                {
                    material.SetTexture ("_FrontTex", frontCamera.RenderTexture);
                }

                if (backCamera != null)
                {
                    material.SetTexture ("_BackTex", backCamera.RenderTexture);
                }
            }
        }

        void refreshVariables ()
        {
            oldScreenWidth = Screen.width;
            oldScreenHeight = Screen.height;
            oldDownscaleFactor = downscaleFactor;
            RenderTextureWidth = Screen.width >> downscaleFactor;
            RenderTextureHeight = Screen.height >> downscaleFactor;
            if (RenderTextureWidth <= 0) RenderTextureWidth = 12;
            if (RenderTextureHeight <= 0) RenderTextureHeight = 12;
        }

        void OnRenderImage (RenderTexture src, RenderTexture dest)
        {
            if (material != null)
            {
                Graphics.Blit (src, dest, material);
            }
            else
            {
                Graphics.Blit (src, dest);
            }
        }

        void Update ()
        {
            if (Screen.width != oldScreenWidth || Screen.height != oldScreenHeight || oldDownscaleFactor != downscaleFactor)
            {
                refreshVariables ();
                refreshTargetTextures ();
                setRenderTextures ();
            }
        }
    }
}

