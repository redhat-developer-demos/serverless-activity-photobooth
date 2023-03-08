FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY photobooth.csproj .
RUN dotnet restore photobooth.csproj
COPY . .
RUN dotnet build photobooth.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish photobooth.csproj -c Release -o /app/publish


FROM docker.io/nginx AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R 1001:0 /var/cache/nginx && chmod -R ug+rwx /var/cache/nginx && chown -R 1001:0 /var/run
USER 1001
EXPOSE 8080