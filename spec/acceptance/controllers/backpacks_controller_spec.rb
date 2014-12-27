require 'spec_helper'

describe BackpacksController, type: :request do
  before(:each) do
    allow_any_instance_of(Services::Weather::Service).to receive(:get_forecast_for_location).with('Wroclaw, Poland', Time.new(2014, 12, 30)).and_return(forecast)
  end

  describe 'GET /backpacks/build' do
    context 'for incorrect request' do
      let(:params) do
        {
          place: 'Wroclaw, Poland',
          date: '2014.12.30',
          accommodation: 'wrong_hotel',
          stay_length: '10',
          reason: 'business'
        }
      end

      let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

      it 'has status 200' do
        get '/backpacks/build', params
        expect(response).to_not be_success
        expect(response.status).to eq(400)
      end

      it 'content type of response is application/json' do
        get '/backpacks/build', params
        expect(response.content_type).to eq('application/json')
      end

      it 'returns correct backpacks' do
        get '/backpacks/build', params
        expect(response.body).to eq('{"code":400,"message":"make sure your request is correct"}')
      end
    end

    context 'for man' do
      context 'for business puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Sweatshirt","quantity":6.0},{"name":"T-Shirt","quantity":9.0},{"name":"Shorts","quantity":1.0},{"name":"Trousers","quantity":7.0},{"name":"Shoes","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":10.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end

      context 'for vacation puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Sweatshirt","quantity":6.0},{"name":"T-Shirt","quantity":9.0},{"name":"Shorts","quantity":1.0},{"name":"Trousers","quantity":7.0},{"name":"Shoes","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":10.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end

      context 'for date puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"T-Shirt","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Tie","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":1.0},{"name":"T-Shirt","quantity":6.0},{"name":"Shirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":1.0},{"name":"Shoes","quantity":3.0},{"name":"FlipFlops","quantity":1.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":1.0},{"name":"Umbrella","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0},{"name":"Shaving Cream","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'man',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Sweatshirt","quantity":6.0},{"name":"T-Shirt","quantity":9.0},{"name":"Shorts","quantity":1.0},{"name":"Trousers","quantity":7.0},{"name":"Shoes","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":10.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'man'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Shirt","quantity":9.0},{"name":"Trousers","quantity":3.0},{"name":"Socks","quantity":10.0},{"name":"Lace-up shoes","quantity":2.0},{"name":"Shoes","quantity":2.0},{"name":"Tie","quantity":2.0},{"name":"Pyjamas","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Mantle","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end
    end

    context 'for woman' do
      context 'for business puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Jersey","quantity":6.0},{"name":"Tank-top","quantity":9.0},{"name":"Skirt","quantity":1.0},{"name":"Dress","quantity":7.0},{"name":"High heels","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":5.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'business',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end

      context 'for vacation puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Jersey","quantity":6.0},{"name":"Tank-top","quantity":9.0},{"name":"Skirt","quantity":1.0},{"name":"Dress","quantity":7.0},{"name":"High heels","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":5.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'vacation',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end

      context 'for date puproses' do
        context 'located in hotel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hotel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in hostel' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'hostel',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":6.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":6.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in rental' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Dress","quantity":7.0},{"name":"Skirt","quantity":3.0},{"name":"Trousers","quantity":3.0},{"name":"Shirt","quantity":4.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0},{"name":"FlipFlops","quantity":1.0},{"name":"Jacket","quantity":1.0},{"name":"Belt","quantity":1.0},{"name":"Gloves","quantity":1.0},{"name":"Scarf","quantity":1.0},{"name":"Towel","quantity":2.0},{"name":"Shampoo","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'rental',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end

        context 'located in tent' do
          context 'if it is warm outside and there are no precipitation' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'woman',
                gadgets: 'camera,mp3_player,notebook,phone,tablet',
                sports: 'fitness,skiing,snowboarding,swimming',
                glasses: 'contact_lenses,glasses'
              }
            end

            let(:forecast) { double('Forecast', temperature: :warm, precip_type: :none) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Holiday backpack","type":"ahp","elements":[{"name":"Jersey","quantity":6.0},{"name":"Tank-top","quantity":9.0},{"name":"Skirt","quantity":1.0},{"name":"Dress","quantity":7.0},{"name":"High heels","quantity":2.0},{"name":"Sneakers","quantity":2.0},{"name":"Flip-flops","quantity":1.0},{"name":"Socks","quantity":5.0},{"name":"Pants","quantity":10.0},{"name":"Jacket","quantity":5.0},{"name":"Sunglasses","quantity":1.0},{"name":"Umbrella","quantity":1.0}]},{"name":"Camera backpack","type":"gadgets","elements":[{"name":"Camera","quantity":1},{"name":"Memory card","quantity":1},{"name":"Camera charger","quantity":1}]},{"name":"MP3 Player backpack","type":"gadgets","elements":[{"name":"MP3 Player","quantity":1},{"name":"MP3 Player charger","quantity":1}]},{"name":"Notebook backpack","type":"gadgets","elements":[{"name":"Notebook","quantity":1},{"name":"Notebook charger","quantity":1}]},{"name":"Phone backpack","type":"gadgets","elements":[{"name":"Phone","quantity":1},{"name":"Phone charger","quantity":1}]},{"name":"Tablet backpack","type":"gadgets","elements":[{"name":"Tablet","quantity":1},{"name":"Tablet charger","quantity":1}]},{"name":"Fitness backpack","type":"sports","elements":[{"name":"Leisurewear","quantity":1},{"name":"Sport shoes","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Skiing backpack","type":"sports","elements":[{"name":"Ski","quantity":2},{"name":"Ski pole","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Ski suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Snowboarding backpack","type":"sports","elements":[{"name":"Snowboard","quantity":2},{"name":"Snowboard shoes","quantity":1},{"name":"Ski goggles","quantity":1},{"name":"Snowboard suit","quantity":1},{"name":"Drawers","quantity":1},{"name":"Ski gloves","quantity":1}]},{"name":"Swimming backpack","type":"sports","elements":[{"name":"Swimwear","quantity":1},{"name":"Cap","quantity":1},{"name":"Swimming goggles","quantity":1},{"name":"Towel","quantity":1},{"name":"Flip-flops","quantity":1}]},{"name":"Contact lenses backpack","type":"glasses","elements":[{"name":"Contact lenses","quantity":10},{"name":"Contact lenses case","quantity":2.0},{"name":"Contact lenses liquid","quantity":1.0},{"name":"Eye drops","quantity":1.0}]},{"name":"Glasses backpack","type":"glasses","elements":[{"name":"Glasses","quantity":1},{"name":"Spectacle case","quantity":1},{"name":"Glasses cloth","quantity":1}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is freezing and snowy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :freezing, precip_type: :snow) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end

          context 'if it is cool and rainy' do
            let(:params) do
              {
                place: 'Wroclaw, Poland',
                date: '2014.12.30',
                accommodation: 'tent',
                stay_length: '10',
                reason: 'date',
                sex: 'woman'
              }
            end

            let(:forecast) { double('Forecast', temperature: :cool, precip_type: :rain) }

            it 'has status 200' do
              get '/backpacks/build', params
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'content type of response is application/json' do
              get '/backpacks/build', params
              expect(response.content_type).to eq('application/json')
            end

            let(:expected_body) do
              '[{"name":"Business backpack","type":"ahp","elements":[{"name":"Suit","quantity":2.0},{"name":"Skirt","quantity":9.0},{"name":"Shirt","quantity":9.0},{"name":"Nylons","quantity":10.0},{"name":"Flat shoes","quantity":2.0},{"name":"High heals","quantity":2.0},{"name":"Nightdress","quantity":1.0},{"name":"Pants","quantity":10.0},{"name":"Coat","quantity":1.0}]}]'
            end

            it 'returns correct backpacks' do
              get '/backpacks/build', params
              expect(response.body).to eq(expected_body)
            end
          end
        end
      end
    end
  end
end