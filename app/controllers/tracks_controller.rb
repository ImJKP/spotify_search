class TracksController < ApplicationController

  def index
    if params[:search]
      search = Typhoeus::Request.new("https://api.spotify.com/v1/search", method: :get, params: {q: params[:search], type: "track"})
      search.run
      results = search.response.body
      results = JSON.parse(results)
      items = results["tracks"]["items"]
      @results = []
      items.each do |item|
        track_id = item["id"]
        title = item["name"]
        artist = item["artists"].first["name"]
        album = item["album"]["name"]
        preview_url = item["preview_url"]
        href = item["href"]
        if item["album"]["images"].first
          image_url = item["album"]["images"].first["url"]
        else
          image_url = "http://4.bp.blogspot.com/_CHG2GRbeET8/SS3f-tcSNiI/AAAAAAAAJEk/qVdRYu1MLMs/s1600/missing-715826.gif"
        end
        @results << {:track_id => track_id, :title => title, :artist => artist, :album => album, :image_url => image_url, :preview_url => preview_url, :href => href }
      end
    end
  render "index"
  end

  def my_tracks
    request = Typhoeus::Request.new(
    URI.escape("https://api.spotify.com/v1/me/tracks"),
    method: :get,
    params: {},
    headers: { "Authorization": session[:spotify_token_type] + " " + session[:spotify_access_token] })
    request.run
    response = JSON.parse(request.response.body)
    response = response["items"]
    @tracks = []
    response.each do |item|
      item = item["track"]
      track_id = item["id"]
      title = item["name"]
      artist = item["artists"].first["name"]
      album = item["album"]["name"]
      preview_url = item["preview_url"]
      href = item["href"]
      if item["album"]["images"].first
        image_url = item["album"]["images"].first["url"]
      else
        image_url = "http://4.bp.blogspot.com/_CHG2GRbeET8/SS3f-tcSNiI/AAAAAAAAJEk/qVdRYu1MLMs/s1600/missing-715826.gif"
      end
    @tracks << {:track_id => track_id, :title => title, :artist => artist, :album => album, :image_url => image_url, :preview_url => preview_url, :href => href }
    end

    render "saved"
  end

  def save_track
    track_id = params[:track_id]
    request = Typhoeus::Request.new(
      URI.escape("https://api.spotify.com/v1/me/tracks"),
      method: :put,
      params: { ids: track_id },
      headers: { "Authorization": session[:spotify_token_type] + " " + session[:spotify_access_token] })
    request.run
    redirect_to my_tracks_path
  end

  def remove_track
    track_id = params[:track_id]
    request = Typhoeus::Request.new(
      URI.escape("https://api.spotify.com/v1/me/tracks"),
      method: :delete,
      params: { ids: track_id },
      headers: { "Authorization": session[:spotify_token_type] + " " + session[:spotify_access_token] })
    request.run
    redirect_to my_tracks_path
  end



end
