FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

COPY FinflowTelemetry.slnx .
COPY Telemetry-Api/Telemetry-Api.csproj ./Telemetry-Api/
COPY Test/Test.csproj ./Test/

RUN dotnet restore

COPY . .

WORKDIR /source/Telemetry-Api
RUN dotnet publish -c Release -o /app /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

#(UID 1654)
USER app

EXPOSE 8080

COPY --from=build /app .

ENTRYPOINT ["dotnet", "Telemetry-Api.dll"]