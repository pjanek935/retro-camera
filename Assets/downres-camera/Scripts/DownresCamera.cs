using UnityEngine;

namespace RetroCamera
{
    [ExecuteInEditMode]
    [RequireComponent (typeof (Camera))]
    public class DownresCamera : MonoBehaviour
    {
        Camera cam;

        public RenderTexture RenderTexture
        {
            get;
            private set;
        }

        public void RefreshTargetTexture (int width, int height, int depth)
        {
            getCameraIfNeeded ();

            if (cam.targetTexture != null)
            {
                cam.targetTexture.Release ();
            }

            RenderTexture = new RenderTexture (width, height, depth, RenderTextureFormat.Default);
            RenderTexture.filterMode = FilterMode.Point;
            cam.targetTexture = RenderTexture;
        }

        void getCameraIfNeeded ()
        {
            if (cam == null)
            {
                cam = GetComponent<Camera> ();
            }
        }
    }
}

