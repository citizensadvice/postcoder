# frozen_string_literal: true

require_relative "../app"

describe "App" do
  describe "status" do
    it "returns 200 status" do
      get "/status"
      expect(last_response).to be_ok
    end
  end

  # TODO: deprecated - remove
  describe "/pcw/" do
    let(:endpoint) { "/pcw/#{api_key}/address/uk/E1" }

    context "with no format" do
      it "returns JSON as default" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1?format=json")
          .to_return(status: 200, body: read_json("E1"))

        get endpoint
        expect(last_response).to be_ok
        expect(last_response.headers["Content-Type"]).to include "json"
        expect(last_response.body).to eq read_json("E1")
      end
    end

    context "with xml format" do
      it "returns XML" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1?format=xml")
          .to_return(status: 200, body: read_json("E1"))

        get "#{endpoint}?format=xml"
        expect(last_response).to be_ok
        expect(last_response.headers["Content-Type"]).to include "xml"
        expect(last_response.body).to eq read_json("E1")
      end
    end

    context "with invalid key" do
      it "returns 403" do
        get "/pcw/INVALID-KEY/address/uk/E1"
        expect(last_response).to be_forbidden
        expect(last_response.body).to eq "Incorrect Search Key (check Status service for additional details)"
        expect(last_response.headers["Content-Type"]).to include "text/plain"
      end
    end

    context "with timeout" do
      it "returns 504" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_timeout

        get "/pcw/#{api_key}/address/uk/T1"
        expect(last_response.status).to eq 504
        expect(last_response.body).to eq ""
      end
    end

    context "with error response" do
      it "returns 500" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_return(status: 500, body: "foo")

        get "/pcw/#{api_key}/address/uk/T1"
        expect(last_response.status).to eq 500
        expect(last_response.body).to eq "response error: 500 Internal Server Error: foo"
      end
    end

    context "with 404 response" do
      it "returns 404" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_return(status: 404, body: "foo")

        get "/pcw/#{api_key}/address/uk/T1"
        expect(last_response.status).to eq 500
        expect(last_response.body).to eq "response error: 404 Not Found: foo"
      end
    end

    describe "caching" do
      let(:endpoint) { "/pcw/#{api_key}/address/uk/E1" }

      it "removes invalid keys from cache key" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "#{endpoint}?format=xml&lines=1&invalid=key"
        expect(Cache).to have_received(:get).with('E1/{"format"=>"xml", "lines"=>"1"}')
        expect(last_response).to be_ok
      end

      it "formats postcode with spaces" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/pcw/#{api_key}/address/uk/E1%203AH"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "formats postcode with multiple spaces" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/pcw/#{api_key}/address/uk/E1%20%20%203AH%20"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "upcases the query" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/pcw/#{api_key}/address/uk/e1%203ah"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "does not request if cached" do
        allow(Cache).to receive(:get).and_return(read_json("E1"))
        get endpoint
        expect(last_response).to be_ok
      end

      it "sets cache if new key" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get).and_return(nil)
        allow(Cache).to receive(:set)
        get "/pcw/#{api_key}/address/uk/N2"
        expect(last_response).to be_ok
        expect(Cache).to have_received(:get).once.with('N2/{"format"=>"json"}')
        expect(Cache).to have_received(:set).once
      end

      it "does not set the cache if an error" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 500, body: read_json("E1"))
        allow(Cache).to receive(:set)
        get "/pcw/#{api_key}/address/uk/N2"
        expect(last_response.status).to eq 500
        expect(Cache).not_to have_received(:set)
      end
    end
  end

  describe "/addresses/" do
    let(:endpoint) { "/addresses/E1" }

    context "with no format" do
      it "returns JSON as default" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1?format=json")
          .to_return(status: 200, body: read_json("E1"))

        get endpoint
        expect(last_response).to be_ok
        expect(last_response.headers["Content-Type"]).to include "json"
        expect(last_response.body).to eq read_json("E1")
      end
    end

    context "with xml format" do
      it "returns XML" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1?format=xml")
          .to_return(status: 200, body: read_json("E1"))

        get "#{endpoint}?format=xml"
        expect(last_response).to be_ok
        expect(last_response.headers["Content-Type"]).to include "xml"
        expect(last_response.body).to eq read_json("E1")
      end
    end

    context "with timeout" do
      it "returns 500" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_timeout

        get "/addresses/T1"
        expect(last_response.status).to eq 504
        expect(last_response.body).to eq ""
      end
    end

    context "with error response" do
      it "returns 500" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_return(status: 500, body: "foo")

        get "/addresses/T1"
        expect(last_response.status).to eq 500
        expect(last_response.body).to eq "response error: 500 Internal Server Error: foo"
      end
    end

    context "with 404 response" do
      it "returns 404" do
        stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/T1?format=json")
          .to_return(status: 404, body: "foo")

        get "/addresses/T1"
        expect(last_response.status).to eq 500
        expect(last_response.body).to eq "response error: 404 Not Found: foo"
      end
    end

    describe "caching" do
      it "removes invalid keys from cache key" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/addresses/E1?format=xml&lines=1&invalid=key"
        expect(Cache).to have_received(:get).with('E1/{"format"=>"xml", "lines"=>"1"}')
        expect(last_response).to be_ok
      end

      it "formats postcode with spaces" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/addresses/E1%203AH"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "formats postcode with multiple spaces" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/addresses/E1%20%20%203AH%20"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "upcases the query" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        get "/addresses/e1%203ah"
        expect(Cache).to have_received(:get).with('E1 3AH/{"format"=>"json"}')
        expect(last_response).to be_ok
      end

      it "does not request if cached" do
        allow(Cache).to receive(:get).and_return(read_json("E1"))
        get endpoint
        expect(last_response).to be_ok
      end

      it "sets cache if new key" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get).and_return(nil)
        allow(Cache).to receive(:set)
        get "/addresses/N2"
        expect(last_response).to be_ok
        expect(Cache).to have_received(:get).once.with('N2/{"format"=>"json"}')
        expect(Cache).to have_received(:set).once
      end

      it "sets cache if params refresh is set" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 200, body: read_json("E1"))
        allow(Cache).to receive(:get)
        allow(Cache).to receive(:set)
        get "/addresses/N2?refresh=true"
        expect(last_response).to be_ok
        expect(Cache).not_to have_received(:get)
        expect(Cache).to have_received(:set).once
      end

      it "does not set the cache if an error" do
        stub_request(:get, %r{https://ws\.postcoder\.com/}).to_return(status: 500, body: read_json("E1"))
        allow(Cache).to receive(:set)
        get "/addresses/N2?refresh=true"
        expect(last_response.status).to eq 500
        expect(Cache).not_to have_received(:set)
      end
    end
  end
end
