class BackpacksController < ApplicationController
  def build
    param! :place,          String#,  required: true
    param! :date,           Date,    default: -> { Time.now }
    param! :accommodation,  String,  in: ['hotel', 'hostel', 'friends_house', 'tent', 'rental'], default: 'hotel'
    param! :stay_length,    Integer, required: true
    param! :reason,         String,  in: ['date', 'business', 'vacation', 'conference']
    param! :sex,            String,  in: ['m', 'w'], transform: :downcase
    param! :gadgets,        Array#,   in: ['camera', 'mp3_player', 'notebook', 'phone', 'tablet']
    param! :sports,         Array#,   in: ['fitness', 'skiing', 'snowboarding', 'swimming']
    param! :glasses,        Array#,   in: ['contact_lenses', 'glasses']

    backpacks = []
    builders.each {|builder| backpacks += builder.new(backpack_params).build }

    render json:            backpacks,
           each_serializer: serializer,
           status:          :ok
  end

  private

  def builders
    [FixedBackpackBuilder]
  end

  def serializer
    BackpackSerializer
  end

  def backpack_params
    params.permit(:place, :accommodation, :stay_length, :reason, :sex, gadgets: [], sports: [], glasses: [])
  end
end
