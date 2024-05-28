resource "aws_api_gateway_resource" "this" {
  count = var.proxy_integration  ? 0 : length(local.path_list)

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = local.path_list[count.index] == "" ? "{proxy+}" : local.path_list[count.index]
}

resource "aws_api_gateway_method" "this" {
  count = var.proxy_integration  ? 0 : length(local.method_list)

  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method          = var.resources[count.index].method
  authorization        = "NONE"
  api_key_required     = var.api_key_required
  request_parameters   = var.resources[count.index].path == "" ? { "method.request.path.proxy" = true } : null
}

resource "aws_api_gateway_integration" "this" {
  count = var.proxy_integration  ? 0 : length(local.method_list)

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method             = element(aws_api_gateway_method.this.*.http_method, count.index)
  integration_http_method = var.resources[count.index].type == "function" ? "POST" : "ANY"
  type                    = var.resources[count.index].type == "function" ? "AWS_PROXY" : "HTTP_PROXY"
  uri                     = var.resources[count.index].type == "function" ? "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.resources[count.index].end_point}/invocations" : var.resources[count.index].type == "container" ? "${var.resources[count.index].end_point}/{proxy}" : var.resources[count.index].end_point
  connection_type         = var.resources[count.index].type == "function" ? null : var.resources[count.index].type == "container" ? "VPC_LINK" : "INTERNET"
  connection_id           = var.resources[count.index].type == "function" ? null : var.resources[count.index].type == "container" ? var.vpc-link : null
  passthrough_behavior    = var.resources[count.index].path == "" ? "WHEN_NO_MATCH" : null
  request_parameters      = var.resources[count.index].path == "" ? { "integration.request.path.proxy" = "method.request.path.proxy" } : var.headers_custom

  depends_on = [
    aws_api_gateway_method.this, aws_api_gateway_resource.this
  ]
}

resource "aws_api_gateway_resource" "proxy" {
  count = var.proxy_integration  ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : length(local.path_list) : length(local.path_list) 

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = element(aws_api_gateway_resource.this.*.id, count.index)
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "proxy" {
  count = var.proxy_integration  ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : length(local.method_list) : length(local.method_list)

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method             = element(aws_api_gateway_method.proxy.*.http_method, count.index)
  integration_http_method = var.resources[count.index].type == "function" ? "POST" : "ANY"
  type                    = var.resources[count.index].type == "function" ? "AWS_PROXY" : "HTTP_PROXY"
  uri                     = var.resources[count.index].type == "function" ? "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.resources[count.index].end_point}/invocations" : "${var.resources[count.index].end_point}/{proxy}"
  connection_type         = var.resources[count.index].type == "function" ? null : var.resources[count.index].type == "container" ? "VPC_LINK" : "INTERNET"
  connection_id           = var.resources[count.index].type == "function" ? null : var.resources[count.index].type == "container" ? var.vpc-link : null
  request_parameters      = var.resources[count.index].type == "function" ? null : var.resources[count.index].type == "container" ? { "integration.request.path.proxy" = "method.request.path.proxy" } : null
  passthrough_behavior    = "WHEN_NO_MATCH"

  depends_on = [
    aws_api_gateway_method.proxy, aws_api_gateway_resource.proxy
  ]
}

resource "aws_api_gateway_method" "proxy" {
  count = var.proxy_integration ? 0 :  (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : length(local.method_list) : length(local.method_list) 

  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method          = var.resources[count.index].method
  authorization        = "NONE"
  api_key_required     = var.api_key_required
  request_parameters   = { "method.request.path.proxy" = true }
}

# Implementando Options no resource

resource "aws_api_gateway_method" "options" {
  count = var.proxy_integration ? 0 : (var.use_options ? length(local.path_list) : 0)

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = [aws_api_gateway_resource.this]
}

resource "aws_api_gateway_method_response" "options" {
  count = var.proxy_integration ? 0 : (var.use_options ? length(local.path_list) : 0)

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method = element(aws_api_gateway_method.options.*.http_method, count.index)
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

resource "aws_api_gateway_integration" "options" {
  count = var.proxy_integration  ? 0 : (var.use_options ? length(local.path_list) : 0)

  content_handling = length(var.binary_media_types) == 0 ? null : var.content_handling
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method      = element(aws_api_gateway_method.options.*.http_method, count.index)
  type             = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration_response" "options" {
  count = var.proxy_integration  ? 0 : (var.use_options ? length(local.path_list) : 0)

  content_handling = length(var.binary_media_types) == 0 ? null : var.content_handling
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = element(aws_api_gateway_resource.this.*.id, count.index)
  http_method      = element(aws_api_gateway_method.options.*.http_method, count.index)
  status_code      = element(aws_api_gateway_method_response.options.*.status_code, count.index)
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }
  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.options]
}

# Implementando Options no proxy

resource "aws_api_gateway_method" "options_proxy" {
  count = var.proxy_integration ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : (var.use_options ? length(local.path_list) : 0) : (var.use_options ? length(local.path_list) : 0)

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method   = "OPTIONS"
  authorization = "NONE"

}

resource "aws_api_gateway_method_response" "options_proxy" {
  count = var.proxy_integration ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : (var.use_options ? length(local.path_list) : 0) : (var.use_options ? length(local.path_list) : 0)

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method = element(aws_api_gateway_method.options_proxy.*.http_method, count.index)
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

  depends_on = [aws_api_gateway_method.options_proxy]
}

resource "aws_api_gateway_integration" "options_proxy" {
  count = var.proxy_integration ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : (var.use_options ? length(local.path_list) : 0) : (var.use_options ? length(local.path_list) : 0)

  content_handling = length(var.binary_media_types) == 0 ? null : var.content_handling
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method      = element(aws_api_gateway_method.options_proxy.*.http_method, count.index)
  type             = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.options_proxy]
}

resource "aws_api_gateway_integration_response" "options_proxy" {
  count = var.proxy_integration  ? 0 : (length(local.path_list) == 1) ? local.path_list[0] == "" ? 0 : (var.use_options ? length(local.path_list) : 0) : (var.use_options ? length(local.path_list) : 0)

  content_handling = length(var.binary_media_types) == 0 ? null : var.content_handling
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = element(aws_api_gateway_resource.proxy.*.id, count.index)
  http_method      = element(aws_api_gateway_method.options_proxy.*.http_method, count.index)
  status_code      = element(aws_api_gateway_method_response.options_proxy.*.status_code, count.index)
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }
  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.options_proxy]
}
