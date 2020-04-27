USERS = ["Mary", "John", "Jim", "Anne", "Robert"]

USERS.each do |x|
    u = User.create(:name => x, :email => "#{x}@example.com", :password => "foobar", :password_confirmation => "foobar")

    (rand(4) + 1).times do
        u.posts.create(:title => "Here is a title", :content => "And here is a lot of content.")
    end
end

USERS.each do |x|
    u = User.find_by(:name => x)

    (rand(4) + 1).times do
        u.comments.create(:content => "This is a random comment", :post_id => rand(1..Post.count))
    end


    idArr = []

    u.posts.each do |x|
        idArr.push(x.id)
    end

    (rand(4) + 1).times do
        randomPostId = rand(1..Post.count)

        if idArr.include?(randomPostId)
            
        else
            u.likes.create(:post_id => randomPostId)
        end
    end


    (rand(2) + 1).times do
        randomUserId = nil

        loop do

            randomUserId = rand(1..User.count)

        break if (u.id != randomUserId)

        end

        u.friends.create(:friend_id => randomUserId)
        User.find_by(:id => randomUserId).friends.create(:friend_id => u.id)
    end

end

USERS.each do |x|
    u = User.find_by(:name => x)

    1.times do
        idArr = [u.id]

        u.friends.each do |x|
            idArr.push(x.friend_id)
        end

        randomUserId = nil

        loop do

            randomUserId = rand(1..User.count)

        break if !idArr.include?(randomUserId)

        end

        u.sent_friend_requests.create(:requestee_id => randomUserId)
    end
end