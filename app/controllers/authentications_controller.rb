class AuthenticationsController < ApplicationController

  def create
    client_id = "ef0a52e548f94683814292d0012d0211"
    response_type = "code"
    redirect_uri = "http://52.34.218.67:3000/auth/callback"
    the_scope = "user-library-read user-library-modify"
    redirect_to("https://accounts.spotify.com/authorize" + "?client_id=" + client_id + "&response_type=" + response_type + "&redirect_uri=" + redirect_uri + "&scope=" + the_scope)
  end

  def callback
    spotify_auth_code = params[:code]

    request = Typhoeus::Request.new(
    URI.escape("https://accounts.spotify.com/api/token"),
    method: :post,
    params: { grant_type: "authorization_code", code: spotify_auth_code, redirect_uri: "http://52.34.218.67:3000/auth/callback", client_id: "ef0a52e548f94683814292d0012d0211", client_secret: "40230093580a491abb79c3260257663b" })

    request.run
    response = JSON.parse(request.response.body)

    session[:spotify_access_token] = response["access_token"]
    session[:spotify_token_type] = response["token_type"]

    redirect_to root_path
  end



end