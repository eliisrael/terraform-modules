###############################################################################################################
#                                           API                                                               #
###############################################################################################################

resource "aws_api_gateway_resource" "path_api" {
  count = var.proxy_integration ? 1 : 0

  path_part   = "api"
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_rest_api.this]
}

resource "aws_api_gateway_method" "path_api_options" {
  count = var.proxy_integration ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.path_api[0].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "path_api_response" {
  count = var.proxy_integration ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_api[0].id
  http_method = aws_api_gateway_method.path_api_options[0].http_method
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

  depends_on = [aws_api_gateway_method.path_api_options]
}

resource "aws_api_gateway_integration" "path_api_integration" {
  count = var.proxy_integration ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_api[0].id
  http_method = aws_api_gateway_method.path_api_options[0].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.path_api_options]
}

resource "aws_api_gateway_integration_response" "path_api_integration_response" {
  count = var.proxy_integration ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_api[0].id
  http_method = aws_api_gateway_method.path_api_options[0].http_method
  status_code = aws_api_gateway_method_response.path_api_response[0].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.path_api_response]
}


###############################################################################################################
#                                           VERSIONS                                                                #
###############################################################################################################

resource "aws_api_gateway_resource" "path_versions" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  path_part   = var.apis_versions[count.index]
  parent_id   = aws_api_gateway_resource.path_api[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.path_api]
}

resource "aws_api_gateway_method" "path_versions_options" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.path_versions[count.index].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "path_versions_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_versions[count.index].id
  http_method = aws_api_gateway_method.path_versions_options[count.index].http_method
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

  depends_on = [aws_api_gateway_method.path_versions_options]
}

resource "aws_api_gateway_integration" "path_versions_integration" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_versions[count.index].id
  http_method = aws_api_gateway_method.path_versions_options[count.index].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.path_versions_options]
}

resource "aws_api_gateway_integration_response" "path_versions_integration_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_versions[count.index].id
  http_method = aws_api_gateway_method.path_versions_options[count.index].http_method
  status_code = aws_api_gateway_method_response.path_versions_response[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.path_versions_response]
}



###############################################################################################################
#                                           External                                                          #
###############################################################################################################

resource "aws_api_gateway_resource" "path_external" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  path_part   = "external"
  parent_id   = aws_api_gateway_resource.path_versions[count.index].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.path_versions]
}

resource "aws_api_gateway_method" "path_external_options" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.path_external[count.index].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "path_external_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_external[count.index].id
  http_method = aws_api_gateway_method.path_external_options[count.index].http_method
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

  depends_on = [aws_api_gateway_method.path_external_options]
}

resource "aws_api_gateway_integration" "path_external_integration" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_external[count.index].id
  http_method = aws_api_gateway_method.path_external_options[count.index].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.path_external_options]
}

resource "aws_api_gateway_integration_response" "path_external_integration_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_external[count.index].id
  http_method = aws_api_gateway_method.path_external_options[count.index].http_method
  status_code = aws_api_gateway_method_response.path_external_response[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.path_external_response]
}





###############################################################################################################
#                                           {proxy+}                                                          #
###############################################################################################################

resource "aws_api_gateway_resource" "path_proxy" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_resource.path_external[count.index].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.path_external]
}

resource "aws_api_gateway_method" "path_proxy_options" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.path_proxy[count.index].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "path_proxy_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_proxy[count.index].id
  http_method = aws_api_gateway_method.path_proxy_options[count.index].http_method
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

  depends_on = [aws_api_gateway_method.path_proxy_options]
}

resource "aws_api_gateway_integration" "path_proxy_integration" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_proxy[count.index].id
  http_method = aws_api_gateway_method.path_proxy_options[count.index].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [aws_api_gateway_method.path_proxy_options]
}

resource "aws_api_gateway_integration_response" "path_proxy_integration_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_proxy[count.index].id
  http_method = aws_api_gateway_method.path_proxy_options[count.index].http_method
  status_code = aws_api_gateway_method_response.path_proxy_response[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = var.access_control_allow_headers
    "method.response.header.Access-Control-Allow-Methods"     = var.access_control_allow_methods
    "method.response.header.Access-Control-Allow-Origin"      = var.access_control_allow_origin
    "method.response.header.Access-Control-Allow-Credentials" = var.access_control_allow_credentials
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.path_proxy_response]
}

resource "aws_api_gateway_method" "path_proxy_any" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = aws_api_gateway_resource.path_proxy[count.index].id
  http_method          = "ANY"
  api_key_required     = var.api_key_required
  authorization        = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "path_proxy_any_response" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.path_proxy[count.index].id
  http_method = aws_api_gateway_method.path_proxy_any[count.index].http_method
  status_code = "200"

  depends_on = [aws_api_gateway_method.path_proxy_any]
}

resource "aws_api_gateway_integration" "path_proxy_any_integration" {
  count = var.proxy_integration ? length(var.apis_versions) : 0

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.path_proxy[count.index].id
  http_method             = aws_api_gateway_method.path_proxy_any[count.index].http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc-link
  uri                     = "${var.resources[0].end_point}/api/${var.apis_versions[count.index]}/external/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  depends_on = [aws_api_gateway_method.path_proxy_any]
}
