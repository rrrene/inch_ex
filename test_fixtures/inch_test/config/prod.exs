import Config

# Force using SSL in production. This also sets the "strict-security-transport" header,
# also known as HSTS. `:force_ssl` is required to be set at compile-time.
config :inch_test, InchTestWeb.Endpoint, force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Configure Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Req

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
