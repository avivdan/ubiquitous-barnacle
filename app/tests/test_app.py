def test_home_route(client):
    """Test the home route returns 200 and correct JSON."""
    response = client.get('/')
    assert response.status_code == 200
    assert response.data == b"<p>Hello, DevOps!</p>"

def test_non_existent_route(client):
    """Test that an undefined route returns 404."""
    response = client.get('/invalid')
    assert response.status_code == 404

def test_echo_route(client):
    """Test the echo route returns 200 and return JSON."""
    json_data = {"message": "Hello, Echo!"}

    response = client.get('/echo', json=json_data)
    assert response.status_code == 200
    assert response.json == {"message": "Hello, Echo!"}

def test_invalid_json_echo_route(client):
    """Test the echo route returns 400 when not JSON."""
    response = client.get('/echo', data="Not a JSON")
    assert response.status_code == 400
    assert response.json == {"error": "Request must be JSON"}