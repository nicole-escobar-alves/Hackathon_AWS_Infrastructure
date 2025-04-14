resource "aws_apigatewayv2_api" "apigw_main" {
  name          = var.api_name
  protocol_type = "HTTP"
}

// cognito authorizer -----------------------------------------------------------
resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id         = aws_apigatewayv2_api.apigw_main.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name            = "example-authorizer"

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${var.cognito_user_pool_id}"
  }
}

// integrations -----------------------------------------------------------
resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.apigw_main.id

  integration_uri    = "http://a9a021bc081f144008acdac96ccb1179-fc813c326598283f.elb.us-east-1.amazonaws.com/{path}"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
}

// routes -----------------------------------------------------------
resource "aws_apigatewayv2_route" "upload" {
  api_id = aws_apigatewayv2_api.apigw_main.id

  route_key = "ANY /upload/{path+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_route" "download" {
  api_id = aws_apigatewayv2_api.apigw_main.id

  route_key = "ANY /download/{path+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
  authorizer_id = aws_apigatewayv2_authorizer.cognito_authorizer.id
  authorization_type = "JWT"
}

// lambda authorizer -----------------------------------------------------------
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.apigw_main.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.apigw_main.id
  route_key = "POST /admin/token"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

// deployment  -----------------------------------------------------------
resource "aws_apigatewayv2_deployment" "deployment" {
  api_id = aws_apigatewayv2_api.apigw_main.id

  depends_on = [
    aws_apigatewayv2_route.gestaopedidos
  ]
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.apigw_main.id
  name        = "$default"
  auto_deploy = true
}