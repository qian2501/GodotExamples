using Godot;
using System;

public partial class Grass : Area2D
{
	private PhysicsBody2D player;

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
		}
		GD.Print("Player left the area");
	}

	public override void _Process(double delta)
	{
		if (player != null) {
			GD.Print("Player global position: " + player.GlobalPosition.ToString());
			GD.Print("Area global position: " + GlobalPosition.ToString());
			GD.Print("Player's relative position in Area: " + (player.GlobalPosition - GlobalPosition).ToString());

			Vector2 distance = player.GlobalPosition - GlobalPosition;
			Sprite2D grass = GetNode<Sprite2D>("Grass");
			int frame;

			if (distance.X < 0)
			{
				// 左侧负方向
				float absX = Mathf.Abs(distance.X);
				if (absX <= 20)
				{
					frame = 5; // 最近
				}
				else if (absX <= 50)
				{
					frame = 4; // 中等距离
				}
				else
				{
					frame = 3; // 最远
				}
			}
			else
			{
				// 右侧正方向
				float absX = distance.X;
				if (absX <= 20)
				{
					frame = 0; // 最近
				}
				else if (absX <= 50)
				{
					frame = 1; // 中等距离
				}
				else
				{
					frame = 2; // 最远
				}
			} 
			grass.Frame = frame;
		}
	}
}
