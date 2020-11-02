using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField] Vector3 speed = new Vector3 (0f, 1f, 0f);
    [SerializeField] float interval = 0.5f;

    float timer = 0;

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;

        if (timer > interval)
        {
            transform.Rotate (speed * Time.deltaTime);
            timer = 0f;
        }
        
    }
}
