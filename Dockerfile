# osnovna slika za zagon
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

# slika za izgradnjo
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["rgis_2.csproj", "./"]
RUN dotnet restore "rgis_2.csproj"
COPY . .
RUN dotnet build "rgis_2.csproj" -c Release -o /app/build

# objava
FROM build AS publish
RUN dotnet publish "rgis_2.csproj" -c Release -o /app/publish /p:UseAppHost=false

# končna slika
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "rgis_2.dll"]