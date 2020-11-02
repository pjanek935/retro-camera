using UnityEngine;

namespace retro_camera
{
    [ExecuteInEditMode]
    public class BlitTexToScreen : MonoBehaviour
    {
        [SerializeField] int downscaleFactor = 0;
        [SerializeField] Material material = null;
        [SerializeField] DownresCamera [] cameras = new DownresCamera [2];

        private int oldScreenWidth;
        private int oldScreenHeight;
        private int oldDownscaleFactor;

        private void Start ()
        {
            refreshTargetTextures ();
            setRenderTextures ();
        }

        private void OnValidate ()
        {
            if (downscaleFactor < 0)
            {
                downscaleFactor = 0;
            }

            refreshTargetTextures ();
            setRenderTextures ();
        }

        void refreshTargetTextures ()
        {
            if (cameras != null)
            {
                foreach (DownresCamera c in cameras)
                {
                    if (c != null)
                    {
                        int width = Screen.width >> downscaleFactor;
                        int height = Screen.height >> downscaleFactor;

                        if (width <= 0) width = 12;
                        if (height <= 0) height = 12;

                        c.RefreshTargetTexture (width, height, 24);
                    }
                }
            }
        }

        void setRenderTextures ()
        {
            if (material != null && cameras != null)
            {
                if (cameras.Length > 0 && cameras [0] != null)
                {
                    material.SetTexture ("_FrontTex", cameras [0].RenderTexture);
                }

                if (cameras.Length > 1 && cameras [1] != null)
                {
                    material.SetTexture ("_BackTex", cameras [1].RenderTexture);
                }
            }
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
                oldScreenWidth = Screen.width;
                oldScreenHeight = Screen.height;
                oldDownscaleFactor = downscaleFactor;
                refreshTargetTextures ();
                setRenderTextures ();
            }
        }
    }
}

