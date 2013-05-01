require_relative "../repositories/feed_repository"
require_relative "../commands/feeds/add_new_feed"

class Stringer < Sinatra::Base
  get "/feeds" do
    @feeds = Feed.order('lower(name)')

    erb :'feeds/index'
  end

  post "/delete_feed" do
    FeedRepository.delete(params[:feed_id])

    status 200
  end

  get "/add_feed" do
    erb :'feeds/add'
  end

  post "/add_feed" do
    feed = AddNewFeed.add(params[:feed_url])

    if feed
      FetchFeeds.enqueue([feed])

      flash[:success] = "We've added your new feed. Check back in a bit."
      redirect to("/")
    else
      flash.now[:error] = "We couldn't find that feed. Try again."
      erb :'feeds/add'
    end
  end
end