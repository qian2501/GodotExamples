using Godot;
using System;

public partial class CharacterBody2d : CharacterBody2D
{
	public const float Speed = 300.0f;
	private Sprite2D depthMapSprite;
	private Image image;
	private ShaderMaterial material;

	public override void _Ready()
	{
		depthMapSprite = GetNode<Sprite2D>("../DepthMap");
		image = depthMapSprite.Texture.GetImage();
		material = (ShaderMaterial)GetNode<Sprite2D>("Icon").Material;
	}

	public override void _PhysicsProcess(double delta)
	{
		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		Velocity = direction * Speed;

		MoveAndSlide();

		Vector2I size = image.GetSize();
		Vector2I samplePosition = (Vector2I)(Position - depthMapSprite.Position + size / 2);

		double depthValue = 0;
		if (samplePosition.X >= 0 && samplePosition.X < size.X 
			&& samplePosition.Y >= 0 && samplePosition.Y < size.Y
		) {
			Color pixel = image.GetPixelv(samplePosition);
			depthValue = pixel.R;
		}

		material.SetShaderParameter("depth_value", depthValue);
	}
}
