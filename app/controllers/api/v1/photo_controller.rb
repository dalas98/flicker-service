class Api::V1::PhotoController < ApplicationController
  def index
    request_params = params[:tags]
    if request_params.nil? 
      url = "https://www.flickr.com/services/feeds/photos_public.gne?format=json"
    else
      url = 'https://www.flickr.com/services/feeds/photos_public.gne?format=json&tags=' + request_params
    end
    response = Excon.get(url)

    return nil if response.status != 200
    response_body = response.body
    response_body.slice! "jsonFlickrFeed("
    response_body.slice! "})"
    parse_json = JSON.parse(response_body+"}")
    items = []
    parse_json['items'].each do |(val)|
      items.append(
        title: val['title'],
        original_link: val['link'],
        image: val['media']['m'],
        date_taken: val['date_taken'],
        published: val['published'],
        author: val['author']
      )
    end
    render json: {
      success: true,
      error: false,
      message: nil,
      data: items
    }
  end
end
