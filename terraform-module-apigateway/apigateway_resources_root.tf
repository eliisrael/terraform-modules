#### root config for apigw that use / like resource

resource "aws_api_gateway_method" "root" {
  count = var.proxy_integration ? 0 : local.path_root != null ? length(local.method_list) : 0

  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = aws_api_gateway_rest_api.this.root_resource_id
  http_method          = var.resources[count.index].method
  authorization        = "NONE"
  api_key_required     = var.api_key_required
  
}

resource "aws_api_gateway_integration" "root" {
  count =  length(local.method_list) 

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = element(aws_api_gateway_method.root.*.http_method, count.index)
  integration_http_method = var.resources[local.path_root].type == "function" ? "POST" : "ANY"
  type                    = var.resources[local.path_root].type == "function" ? "AWS_PROXY" : "HTTP_PROXY"
  uri                     = var.resources[local.path_root].type == "function" ? "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.resources[local.path_root].end_point}/invocations" : var.resources[local.path_root].type == "container" ? "${var.resources[local.path_root].end_point}" : var.resources[local.path_root].end_point
  connection_type         = var.resources[local.path_root].type == "function" ? null : var.resources[local.path_root].type == "container" ? "VPC_LINK" : "INTERNET"
  connection_id           = var.resources[local.path_root].type == "function" ? null : var.resources[local.path_root].type == "container" ? var.vpc-link : null
  passthrough_behavior    = var.resources[local.path_root].path == "" ? "WHEN_NO_MATCH" : null
  request_parameters      = var.headers_custom

  depends_on = [
    aws_api_gateway_method.this, aws_api_gateway_resource.this
  ]
}

resource "aws_api_gateway_method" "options_root" {
  count = var.proxy_integration ? 0 : local.path_root != null ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = [aws_api_gateway_resource.this]
}

resource "aws_api_gateway_method_response" "options_root" {
  count = var.proxy_integration  ? 0 : local.path_root != null ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = element(aws_api_gateway_method.options_root.*.http_method, count.index)
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = false
    "method.response.header.Access-Control-Allow-Methods"     = false
    "method.response.header.Access-Control-Allow-Origin"      = false
    "method.response.header.Access-Control-Allow-Credentials" = false
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration" "options_root" {
  count = var.proxy_integration  ? 0 : local.path_root != null ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = element(aws_api_gateway_method.options_root.*.http_method, count.index)
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.options_root]
}

resource "aws_api_gateway_integration_response" "options_root" {
  count = var.proxy_integration ? 0 : local.path_root != null ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = element(aws_api_gateway_method.options_root.*.http_method, count.index)
  status_code = element(aws_api_gateway_method_response.options_root.*.status_code, count.index)
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }
  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.options_root]
}
