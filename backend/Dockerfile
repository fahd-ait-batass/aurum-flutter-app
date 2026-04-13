FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o /app/bin/server

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server
COPY data /app/data

ENV AURUM_BACKEND_ENV=production
ENV AURUM_BACKEND_HOST=0.0.0.0
ENV PORT=8080
ENV AURUM_BACKEND_DATA_DIR=/app/data
ENV AURUM_ALLOWED_ORIGINS=*

EXPOSE 8080

CMD ["/app/bin/server"]
