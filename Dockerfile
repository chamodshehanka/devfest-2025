FROM ghcr.io/kagent-dev/kagent/kagent-adk:0.7.7

WORKDIR /app

COPY  basic/ basic/
COPY  pyproject.toml pyproject.toml
COPY  README.md README.md
COPY  .python-version .python-version
COPY  uv.lock uv.lock

RUN UV_SKIP_WHEEL_FILENAME_CHECK=1 uv sync --locked --refresh

CMD ["basic"]