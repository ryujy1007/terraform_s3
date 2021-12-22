resource "aws_ami_from_instance" "co777-ami-web" {
  name               = "${var.tag_as_name}-ami-web"
  source_instance_id = var.instance_weba_id

  tags = {
    "Name" = "${var.tag_as_name}_ami_web"
  }
}

resource "aws_ami_from_instance" "co777-ami-was" {
  name               = "${var.tag_as_name}-ami-was"
  source_instance_id = var.instance_wasa_id

  tags = {
    "Name" = "${var.tag_as_name}_ami_was"
  }
}

resource "aws_launch_configuration" "co777-aslc-web" {
  name            = "${var.tag_as_name}-web"
  image_id        = aws_ami_from_instance.co777-ami-web.id
  instance_type   = var.web_ec2_type
  security_groups = [var.security_Web_id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "co777-aslc-was" {
  name            = "${var.tag_as_name}-was"
  image_id        = aws_ami_from_instance.co777-ami-was.id
  instance_type   = var.was_ec2_type
  security_groups = [var.security_WAS_id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "co777-asg-web" {
  name                 = "${var.tag_as_name}-asg-web"
  min_size             = var.as_min_size
  max_size             = var.as_max_size
  desired_capacity     = var.desired_capacity
  health_check_type    = var.health_type
  force_delete         = true
  launch_configuration = aws_launch_configuration.co777-aslc-web.name
  vpc_zone_identifier  = var.subnet_web

  tags = [
    {
      key                 = "Name"
      value               = var.as_web_name
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "co777-asg-was" {
  name                 = "${var.tag_as_name}-asg-was"
  min_size             = var.as_min_size
  max_size             = var.as_max_size
  desired_capacity     = var.desired_capacity
  health_check_type    = var.health_type
  force_delete         = true
  launch_configuration = aws_launch_configuration.co777-aslc-was.name
  vpc_zone_identifier  = var.subnet_was

  tags = [
    {
      key                 = "Name"
      value               = var.as_was_name
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_attachment" "co777-asg-att-web" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-web.id
  alb_target_group_arn   = var.as_web_target
}

resource "aws_autoscaling_attachment" "co777-asg-att-was" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-was.id
}
