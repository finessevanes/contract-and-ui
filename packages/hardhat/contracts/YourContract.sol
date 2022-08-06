pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NightsAndWeekendsDemo is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private ticketId;

    string mintFirstSvg =
        unicode"<svg xmlns='http://www.w3.org/2000/svg' width='400' height='600'><defs><linearGradient id='Gradient' x1='0' x2='0' y1='0' y2='1' cx='0.5' cy='0.5' r='0.5' fx='0.25' fy='0.25'><stop offset='0%' stop-color='#060a1f' /><stop offset='50%' stop-color='#321c3e' /><stop offset='100%' stop-color='#060a1f' /></linearGradient></defs><rect x='10' y='10' width='400' height='600' fill='url(#Gradient)' stroke='black' stroke-width='2' /><text x='35' y='85' font-family='Verdana' font-size='65'>🌙</text><text x='53' y='180' font-weight='bold' font-family='Verdana' font-size='12' fill='rgb(255, 255, 255, .5)'>m3mento presents</text><text x='70' y='265' font-family='Verdana' font-size='50' fill='rgb(250, 204, 21)'>NIGHTS &amp;</text><text x='60' y='310' font-family='Verdana' font-size='50' fill='rgb(250, 204, 21)'>WEEKENDS</text><text x='128' y='342' font-family='Verdana' font-size='23' fill='rgba(250, 204, 21, .9)' font-weight='bold'>DEMO DAY</text><text x='45' y='410' font-family='Verdana' font-size='16' font-weight='bold' fill='white'>WHEN: </text><text x='112' y='410' font-family='Verdana' font-size='16' fill='white'>August 6th, 2022 </text><text x='45' y='440' font-family='Verdana' font-size='16' font-weight='bold' fill='white'>TIME:</text><text x='102' y='440' font-family='Verdana' font-size='16' fill='white'>3:00pm UTC </text><text x='45' y='570' font-family='Verdana' font-size='130'>🦄</text><text x='220' y='550' font-family='Verdana' font-size='65' fill='#ffeffa' font-weight='bold'>";

    string mintLastSvg =
        unicode"</text><svg x='275' y='30' xmlns='http://www.w3.org/2000/svg' height='100' width='100' viewBox='0 0 29 29' rednerAs='svg'><path fill='#060A1F' d='M0,0 h29v29H0z' shape-rendering='crispEdges'></path><path fill='white' d='M0 0h7v1H0zM8 0h5v1H8zM14 0h1v1H14zM16 0h5v1H16zM22,0 h7v1H22zM0 1h1v1H0zM6 1h1v1H6zM8 1h1v1H8zM11 1h4v1H11zM18 1h1v1H18zM22 1h1v1H22zM28,1 h1v1H28zM0 2h1v1H0zM2 2h3v1H2zM6 2h1v1H6zM9 2h6v1H9zM20 2h1v1H20zM22 2h1v1H22zM24 2h3v1H24zM28,2 h1v1H28zM0 3h1v1H0zM2 3h3v1H2zM6 3h1v1H6zM8 3h1v1H8zM15 3h1v1H15zM17 3h1v1H17zM19 3h1v1H19zM22 3h1v1H22zM24 3h3v1H24zM28,3 h1v1H28zM0 4h1v1H0zM2 4h3v1H2zM6 4h1v1H6zM9 4h2v1H9zM13 4h4v1H13zM19 4h2v1H19zM22 4h1v1H22zM24 4h3v1H24zM28,4 h1v1H28zM0 5h1v1H0zM6 5h1v1H6zM9 5h1v1H9zM12 5h1v1H12zM14 5h1v1H14zM16 5h1v1H16zM19 5h2v1H19zM22 5h1v1H22zM28,5 h1v1H28zM0 6h7v1H0zM8 6h1v1H8zM10 6h1v1H10zM12 6h1v1H12zM14 6h1v1H14zM16 6h1v1H16zM18 6h1v1H18zM20 6h1v1H20zM22,6 h7v1H22zM8 7h1v1H8zM10 7h10v1H10zM0 8h1v1H0zM2 8h2v1H2zM5 8h3v1H5zM9 8h1v1H9zM13 8h6v1H13zM22 8h1v1H22zM25 8h1v1H25zM27,8 h2v1H27zM0 9h3v1H0zM4 9h1v1H4zM8 9h1v1H8zM16 9h1v1H16zM18 9h7v1H18zM28,9 h1v1H28zM0 10h2v1H0zM4 10h1v1H4zM6 10h4v1H6zM11 10h1v1H11zM14 10h1v1H14zM16 10h1v1H16zM18 10h1v1H18zM21 10h1v1H21zM23 10h1v1H23zM26 10h2v1H26zM0 11h1v1H0zM3 11h3v1H3zM8 11h1v1H8zM13 11h2v1H13zM18 11h1v1H18zM22 11h3v1H22zM28,11 h1v1H28zM4 12h1v1H4zM6 12h1v1H6zM8 12h1v1H8zM10 12h1v1H10zM12 12h1v1H12zM15 12h1v1H15zM17 12h1v1H17zM20 12h1v1H20zM25 12h2v1H25zM0 13h1v1H0zM2 13h4v1H2zM7 13h1v1H7zM9 13h5v1H9zM15 13h2v1H15zM19 13h1v1H19zM21 13h2v1H21zM26,13 h3v1H26zM0 14h2v1H0zM5 14h3v1H5zM9 14h2v1H9zM14 14h1v1H14zM19 14h1v1H19zM22 14h2v1H22zM26,14 h3v1H26zM0 15h1v1H0zM2 15h3v1H2zM10 15h2v1H10zM13 15h1v1H13zM18 15h3v1H18zM22 15h1v1H22zM27 15h1v1H27zM0 16h1v1H0zM3 16h1v1H3zM6 16h1v1H6zM8 16h1v1H8zM10 16h3v1H10zM15 16h1v1H15zM18 16h4v1H18zM23 16h3v1H23zM27 16h1v1H27zM5 17h1v1H5zM8 17h1v1H8zM11 17h3v1H11zM15 17h1v1H15zM18 17h1v1H18zM21 17h1v1H21zM23 17h1v1H23zM25 17h3v1H25zM0 18h1v1H0zM3 18h4v1H3zM9 18h1v1H9zM11 18h2v1H11zM15 18h2v1H15zM20 18h2v1H20zM23 18h2v1H23zM26 18h1v1H26zM2 19h2v1H2zM9 19h1v1H9zM11 19h1v1H11zM16 19h2v1H16zM26 19h1v1H26zM1 20h2v1H1zM6 20h2v1H6zM9 20h5v1H9zM16 20h11v1H16zM8 21h1v1H8zM12 21h3v1H12zM16 21h1v1H16zM20 21h1v1H20zM24,21 h5v1H24zM0 22h7v1H0zM8 22h2v1H8zM12 22h2v1H12zM16 22h1v1H16zM19 22h2v1H19zM22 22h1v1H22zM24 22h2v1H24zM27 22h1v1H27zM0 23h1v1H0zM6 23h1v1H6zM8 23h4v1H8zM18 23h1v1H18zM20 23h1v1H20zM24 23h2v1H24zM27,23 h2v1H27zM0 24h1v1H0zM2 24h3v1H2zM6 24h1v1H6zM9 24h3v1H9zM14 24h2v1H14zM17 24h2v1H17zM20 24h5v1H20zM26 24h1v1H26zM0 25h1v1H0zM2 25h3v1H2zM6 25h1v1H6zM8 25h1v1H8zM11 25h2v1H11zM14 25h3v1H14zM19 25h1v1H19zM21 25h1v1H21zM24 25h2v1H24zM28,25 h1v1H28zM0 26h1v1H0zM2 26h3v1H2zM6 26h1v1H6zM8 26h1v1H8zM11 26h2v1H11zM14 26h1v1H14zM18 26h2v1H18zM23 26h1v1H23zM26 26h1v1H26zM28,26 h1v1H28zM0 27h1v1H0zM6 27h1v1H6zM10 27h1v1H10zM12 27h2v1H12zM16 27h1v1H16zM20 27h2v1H20zM25 27h1v1H25zM27 27h1v1H27zM0 28h7v1H0zM8 28h1v1H8zM10 28h3v1H10zM16 28h1v1H16zM18 28h4v1H18zM23 28h1v1H23zM27 28h1v1H27z' shape-rendering='crispEdges'></path></svg></svg>";

    string checkInFirstSvg =
        unicode"<svg xmlns='http://www.w3.org/2000/svg' width='400' height='600'><defs><linearGradient id='a' x1='0' x2='0' y1='0' y2='1'><stop offset='0%' stop-color='#060a1f'/><stop offset='50%' stop-color='#321c3e'/><stop offset='100%' stop-color='#060a1f'/></linearGradient></defs><path fill='url(#a)' stroke='#000' stroke-width='2' d='M10 10h400v600H10z'/><text x='35' y='85' font-family='Verdana' font-size='65'>🌙</text><text x='53' y='180' font-weight='bold' font-family='Verdana' font-size='12' fill='rgb(255, 255, 255, .5)'>m3mento presents</text><text x='70' y='265' font-family='Verdana' font-size='50' fill='#FACC15'>ATTENDED</text><text x='128' y='310' font-family='Verdana' font-size='23' fill='rgba(250, 204, 21, .9)' font-weight='bold'>DEMO DAY</text><text x='45' y='460' font-family='Verdana' font-size='130'>🥳</text><text x='220' y='460' font-family='Verdana' font-size='65' fill='#f700aa' font-weight='bold'>";

    string checkInLastSvg =
        unicode"</text><text x='45' y='530' font-family='Verdana' font-size='16' font-weight='bold' fill='rgba(255, 255, 255, .6)'>WHEN: </text><text x='112' y='530' font-family='Verdana' font-size='16' fill='rgba(255, 255, 255, .6)'>August 6th, 2022 </text><text x='45' y='560' font-family='Verdana' font-size='16' font-weight='bold' fill='rgba(255, 255, 255, .6)'>TIME:</text><text x='102' y='560' font-family='Verdana' font-size='16' fill='rgba(255, 255, 255, .6)'>3:00pm UTC </text><svg x='275' y='30' xmlns='http://www.w3.org/2000/svg' height='100' width='100' viewBox='0 0 29 29'><path fill='#060A1F' d='M0 0h29v29H0z' shape-rendering='crispEdges'/><path fill='#fff' d='M0 0h7v1H0zm8 0h5v1H8zm6 0h1v1h-1zm2 0h5v1h-5zm6 0h7v1h-7zM0 1h1v1H0zm6 0h1v1H6zm2 0h1v1H8zm3 0h4v1h-4zm7 0h1v1h-1zm4 0h1v1h-1zm6 0h1v1h-1zM0 2h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm3 0h6v1H9zm11 0h1v1h-1zm2 0h1v1h-1zm2 0h3v1h-3zm4 0h1v1h-1zM0 3h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm2 0h1v1H8zm7 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm3 0h1v1h-1zm2 0h3v1h-3zm4 0h1v1h-1zM0 4h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm3 0h2v1H9zm4 0h4v1h-4zm6 0h2v1h-2zm3 0h1v1h-1zm2 0h3v1h-3zm4 0h1v1h-1zM0 5h1v1H0zm6 0h1v1H6zm3 0h1v1H9zm3 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm3 0h2v1h-2zm3 0h1v1h-1zm6 0h1v1h-1zM0 6h7v1H0zm8 0h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h7v1h-7zM8 7h1v1H8zm2 0h10v1H10zM0 8h1v1H0zm2 0h2v1H2zm3 0h3v1H5zm4 0h1v1H9zm4 0h6v1h-6zm9 0h1v1h-1zm3 0h1v1h-1zm2 0h2v1h-2zM0 9h3v1H0zm4 0h1v1H4zm4 0h1v1H8zm8 0h1v1h-1zm2 0h7v1h-7zm10 0h1v1h-1zM0 10h2v1H0zm4 0h1v1H4zm2 0h4v1H6zm5 0h1v1h-1zm3 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm3 0h1v1h-1zm2 0h1v1h-1zm3 0h2v1h-2zM0 11h1v1H0zm3 0h3v1H3zm5 0h1v1H8zm5 0h2v1h-2zm5 0h1v1h-1zm4 0h3v1h-3zm6 0h1v1h-1zM4 12h1v1H4zm2 0h1v1H6zm2 0h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zm3 0h1v1h-1zm2 0h1v1h-1zm3 0h1v1h-1zm5 0h2v1h-2zM0 13h1v1H0zm2 0h4v1H2zm5 0h1v1H7zm2 0h5v1H9zm6 0h2v1h-2zm4 0h1v1h-1zm2 0h2v1h-2zm5 0h3v1h-3zM0 14h2v1H0zm5 0h3v1H5zm4 0h2v1H9zm5 0h1v1h-1zm5 0h1v1h-1zm3 0h2v1h-2zm4 0h3v1h-3zM0 15h1v1H0zm2 0h3v1H2zm8 0h2v1h-2zm3 0h1v1h-1zm5 0h3v1h-3zm4 0h1v1h-1zm5 0h1v1h-1zM0 16h1v1H0zm3 0h1v1H3zm3 0h1v1H6zm2 0h1v1H8zm2 0h3v1h-3zm5 0h1v1h-1zm3 0h4v1h-4zm5 0h3v1h-3zm4 0h1v1h-1zM5 17h1v1H5zm3 0h1v1H8zm3 0h3v1h-3zm4 0h1v1h-1zm3 0h1v1h-1zm3 0h1v1h-1zm2 0h1v1h-1zm2 0h3v1h-3zM0 18h1v1H0zm3 0h4v1H3zm6 0h1v1H9zm2 0h2v1h-2zm4 0h2v1h-2zm5 0h2v1h-2zm3 0h2v1h-2zm3 0h1v1h-1zM2 19h2v1H2zm7 0h1v1H9zm2 0h1v1h-1zm5 0h2v1h-2zm10 0h1v1h-1zM1 20h2v1H1zm5 0h2v1H6zm3 0h5v1H9zm7 0h11v1H16zm-8 1h1v1H8zm4 0h3v1h-3zm4 0h1v1h-1zm4 0h1v1h-1zm4 0h5v1h-5zM0 22h7v1H0zm8 0h2v1H8zm4 0h2v1h-2zm4 0h1v1h-1zm3 0h2v1h-2zm3 0h1v1h-1zm2 0h2v1h-2zm3 0h1v1h-1zM0 23h1v1H0zm6 0h1v1H6zm2 0h4v1H8zm10 0h1v1h-1zm2 0h1v1h-1zm4 0h2v1h-2zm3 0h2v1h-2zM0 24h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm3 0h3v1H9zm5 0h2v1h-2zm3 0h2v1h-2zm3 0h5v1h-5zm6 0h1v1h-1zM0 25h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm2 0h1v1H8zm3 0h2v1h-2zm3 0h3v1h-3zm5 0h1v1h-1zm2 0h1v1h-1zm3 0h2v1h-2zm4 0h1v1h-1zM0 26h1v1H0zm2 0h3v1H2zm4 0h1v1H6zm2 0h1v1H8zm3 0h2v1h-2zm3 0h1v1h-1zm4 0h2v1h-2zm5 0h1v1h-1zm3 0h1v1h-1zm2 0h1v1h-1zM0 27h1v1H0zm6 0h1v1H6zm4 0h1v1h-1zm2 0h2v1h-2zm4 0h1v1h-1zm4 0h2v1h-2zm5 0h1v1h-1zm2 0h1v1h-1zM0 28h7v1H0zm8 0h1v1H8zm2 0h3v1h-3zm6 0h1v1h-1zm2 0h4v1h-4zm5 0h1v1h-1zm4 0h1v1h-1z' shape-rendering='crispEdges'/></svg></svg>";

    string zeros = "";

    bool public saleIsActive = true;
    uint256 public totalTickets = 999;
    uint256 public availableTickets = 999;
    uint256 public ticketPrice = 1;

    mapping(address => uint256[]) public ticketHolderIds;
    mapping(uint256 => bool) public checkIns;

    constructor() ERC721("Nights & Weekends", "NWS001") {
        ticketId.increment();
    }

    function checkIn(uint256 tokenId) public {
        require(checkIns[tokenId] == false, "Already checked in");
        checkIns[tokenId] = true;
        uint256 currentTicketId = tokenId;
        string memory stringTicketId = Strings.toString(currentTicketId);

        if (currentTicketId < 10) {
            zeros = "00";
        }

        if (currentTicketId > 9 && currentTicketId < 100) {
            zeros = "0";
        }

        string memory finalSvg = string(
            abi.encodePacked(
                checkInFirstSvg,
                zeros,
                stringTicketId,
                checkInLastSvg
            )
        );

        string memory metaData = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Nights & Weekends Season 1", "description": "500 builders shipping for 6 weeks. GTFOL or GTFO", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "attributes": [{"trait_type": "Check In", "value": "true"}]}'
                    )
                )
            )
        );
        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", metaData)
        );

        _setTokenURI(tokenId, tokenURI);
    }

    function mint() public payable {
        require(availableTickets > 0, "Sold out");
        require(saleIsActive, "Tickets are not on sale");
        require(msg.value >= ticketPrice, "You need to pay");
        uint256 currentTicketId = ticketId.current();
        string memory stringTicketId = Strings.toString(currentTicketId);

        if (currentTicketId < 10) {
            zeros = "00";
        }

        if (currentTicketId > 9 && currentTicketId < 100) {
            zeros = "0";
        }

        string memory finalSvg = string(
            abi.encodePacked(mintFirstSvg, zeros, stringTicketId, mintLastSvg)
        );

        string memory metaData = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Nights & Weekends Season 1", "description": "500 builders shipping for 6 weeks. GTFOL or GTFO", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "attributes": [{"trait_type": "Check In", "value": "false"}]}'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", metaData)
        );

        _safeMint(msg.sender, ticketId.current());
        _setTokenURI(ticketId.current(), tokenURI);

        ticketHolderIds[msg.sender].push(ticketId.current());
        ticketId.increment();
        availableTickets = availableTickets - 1;
    }

    function getAvailableTickets() public view returns (uint256) {
        return availableTickets;
    }

    function getTotalTickets() public view returns (uint256) {
        return totalTickets;
    }

    function getCurrentId() public view returns (uint256) {
        return ticketId.current();
    }

    function openSale() public onlyOwner {
        saleIsActive = true;
    }

    function closeSale() public onlyOwner {
        saleIsActive = false;
    }

    function getSaleOpen() public view returns (bool) {
        return saleIsActive;
    }

    function getUserTickets() public view returns (uint256[] memory) {
        return ticketHolderIds[msg.sender];
    }
}
