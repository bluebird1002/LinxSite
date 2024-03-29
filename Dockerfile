FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80


FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src

RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser

COPY ["LinxSite.csproj", ""]
RUN dotnet restore "./LinxSite.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "LinxSite.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LinxSite.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LinxSite.dll"]