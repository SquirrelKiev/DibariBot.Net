# syntax=docker/dockerfile:1

ARG BUILDPLATFORM

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:7.0 as build-env

WORKDIR /source

COPY DibariBot/*.csproj DibariBot/

ARG TARGETARCH

RUN dotnet restore DibariBot/ -a $TARGETARCH

COPY . .

RUN set -xe; \
dotnet publish -c Release -a $TARGETARCH -o /app; \
chmod +x /app/DibariBot

FROM mcr.microsoft.com/dotnet/runtime:7.0 as runtime

WORKDIR /app

COPY --from=build-env /app .

VOLUME [ "/data" ]

ENV DIBARI_CONFIG_LOCATION /data/botconfig.toml

CMD dotnet DibariBot.dll
