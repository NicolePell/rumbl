defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  alias Rumbl.Video

  @valid_attrs %{url: "http://youtu.be", title: "video", description: "a video"}
  @invalid_attrs %{title: "invalid"}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123"))
    ], fn conn -> 
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "sharkey"
  test "list all user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "Shiver me timbers")
    other_video = insert_video(insert_user(username: "other"), title: "Yohoho and a bottle of rum")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  describe "creating videos" do
    @tag login_as: "sharkey"
    test "creates user video and redirects", %{conn: conn, user: user} do
      conn = post conn, video_path(conn, :create), video: @valid_attrs
      assert redirected_to(conn) == video_path(conn, :index)
      assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
    end

    @tag login_as: "sharkey"
    test "does not create video and renders errors when invalid", %{conn: conn} do
      count_before = video_count(Video)
      conn = post conn, video_path(conn, :create), video: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert video_count(Video) == count_before
    end
  end

  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))

end