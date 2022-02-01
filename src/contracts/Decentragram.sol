// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.7.0 <=0.9.0;

contract Decentragram {

	uint128 public imageCount = 0;
	mapping(uint128 => Image) public images;

	struct Image {
		uint128 id;
		string hash;
		string description;
		uint tipAmount;
		address author;
	}

	event ImageCreated (
		uint128 id,
		string hash,
		string description,
		uint tipAmount,
		address author
	);

	event ImageTipped (
		uint128 id,
		string hash,
		string description,
		uint tipAmount,
		address author
	);

	constructor () {}

	function uploadImage(string memory _imgHash, string memory _description)public { 
	require(bytes(_imgHash).length > 0 , "You should provide an image");
	require(bytes(_description).length > 0, "You should provide a description to the image");
	require(msg.sender != address(0));

	imageCount++;

	images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

	emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
}

	function tipImageOwner(uint128 _id) public payable {
	
	require(_id > 0 && _id <= imageCount, "That is not a valid image");

	Image memory _image = images[_id];

    (bool sent, bytes memory data) = _image.author.call{value: msg.value}("");

	_image.tipAmount += msg.value;
	
	//We overrode the last struct, but we maintained the description parameter since we did not overrode it specifically.
	images[_id] = _image;

	emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _image.author);
	
}

}

