require 'lib/liferay_webservices'
LiferayWebservices.init
@client = LiferayWebservices.new_client :user
@user = LiferayWebservices.execute(:get_user_by_id) {|s| s.body = {:id => 10144} }