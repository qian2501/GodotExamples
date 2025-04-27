using Godot;
using System;

public partial class Grass2 : Area2D
{
    private MultiMeshInstance2D gpuInstance;
    private PhysicsBody2D player;
    private MultiMesh multimesh;
    private const float MAX_DISTANCE = 80.0f; // 压力影响最大距离

    public void HandleBodyEnter(PhysicsBody2D body)
    {
        player = body;
        GD.Print("Player entered the area");
    }

    public void HandleBodyExit(PhysicsBody2D body)
    {
        if (player == body)
        {
            player = null;
            ResetAllPressure();
        }
        GD.Print("Player left the area");
    }

    private void InitializeMultiMesh()
    {
        // 配置MultiMesh
        multimesh = gpuInstance.Multimesh;
        multimesh.InstanceCount = 100;

        // 生成随机位置
        var rng = new RandomNumberGenerator();
        for (int i = 0; i < multimesh.InstanceCount; i++)
        {
            Vector2 position = new Vector2(
                rng.RandfRange(-80, 80), 
                rng.RandfRange(-60, 60)
            );
            Transform2D transform = new Transform2D(0, position);
            multimesh.SetInstanceTransform2D(i, transform);
            multimesh.SetInstanceCustomData(i, new Color(0, 0, 0, 0));
        }
    }

    private float CalculatePressure(float distance)
    {
        // 距离越近压力值越大
        return Mathf.Clamp(1.0f - (distance / MAX_DISTANCE), 0, 1);
    }

    private void ResetAllPressure()
    {
        // 重置所有实例的压力值
        for (int i = 0; i < multimesh.InstanceCount; i++)
            multimesh.SetInstanceCustomData(i, new Color(0, 0, 0, 0));
    }

    public override void _Ready()
    {
        gpuInstance = GetNode<MultiMeshInstance2D>("MultiMeshInstance2D");
        InitializeMultiMesh();
    }

    public override void _Process(double delta)
    {
        if (player == null) return;

        Vector2 playerPos = player.GlobalPosition;
        
        // 更新所有实例的压力值
        for (int i = 0; i < multimesh.InstanceCount; i++)
        {
            Transform2D transform = multimesh.GetInstanceTransform2D(i);
            Vector2 grassPos = ToGlobal(transform.Origin);
            Vector2 distVec = grassPos - playerPos;
            
            float distance = distVec.Length();
            float pressure = distVec.Sign().X * CalculatePressure(distance);
            multimesh.SetInstanceCustomData(i, new Color(pressure, 0, 0, 0));
        }
    }
}