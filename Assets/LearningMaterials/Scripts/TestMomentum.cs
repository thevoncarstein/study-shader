using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMomentum : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0)) {
            var force = Vector3.forward;
            var length = transform.position;
            var torque = Vector3.Cross(force, length);
            GetComponent<Rigidbody>().AddTorque(torque);
        }
    }
}
