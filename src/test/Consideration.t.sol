// SPDX-License-Identifier: MIT
//Author: CupOJoseph

pragma solidity 0.8.13;

import "ds-test/test.sol";
import { OrderType, BasicOrderType, ItemType, Side } from "../../contracts/lib/ConsiderationEnums.sol";
import { AdditionalRecipient } from "../../contracts/lib/ConsiderationStructs.sol";
import "../../contracts/Consideration.sol";
import "src/test/NFT721.sol";
import "src/test/CheatCodes.sol";

//use solmate tokens


contract ConsiderationTest is DSTest {
    Consideration consider;
    address considerAddress;

    CheatCodes internal vm;

    address accountA;
    address accountB;
    address accountC;

    address test721Address;
    NFT test721;

    address zone;

    function setUp() public {
        vm = CheatCodes(HEVM_ADDRESS);
        zone = address(0);

        considerAddress = address(new Consideration(address(0), address(0)));
        consider = Consideration(consider);

        //deploy a test 721
        test721Address = address(new NFT("Nifty", "NFT"));
        test721 = NFT(test721Address);

        accountA = vm.addr(1);
        accountB = vm.addr(2);
        accountC = vm.addr(3);

        for (uint256 i; i < 10; i++) {
            test721.mintTo(accountA);
        }
        emit log("Account A airdropped 10 NFTs.");

        vm.prank(accountA);
        test721.setApprovalForAll(considerAddress, true);
        vm.prank(accountB);
        test721.setApprovalForAll(considerAddress, true);
        vm.prank(accountC);
        test721.setApprovalForAll(considerAddress, true);
        emit log("Accounts A B C have approved consideration.");

        vm.label(accountA, "Account A");
    }

    //basic Order

    //eth to 721
    //accountA is offering their 721 for ETH
    function testListBasicETHto721(
        uint256 _id,
        uint256 _ethAmount,
        bytes32 _zoneHash,
        uint256 _salt
    ) external {
        vm.assume(_id > 0);
        vm.assume(_id < 10);
        emit log("Basic Order");

        OfferItem memory offerItem = OfferItem(
            ItemType.ERC721,
            test721Address,
            _id,
            1,
            1
        );

        OfferItem[] memory offer = new OfferItem[](1);
        offer[0] = offerItem;

        ConsiderationItem memory considerationItem = ConsiderationItem(
            ItemType.NATIVE,
            address(0),
            0,
            _ethAmount,
            _ethAmount,
            payable(accountA)
        );
        ConsiderationItem[] memory consideration = new ConsiderationItem[](1);
        consideration[0] = considerationItem;

        uint256 nonce = consider.getNonce(accountA);
        //getOrderHash
        OrderComponents memory orderComponents = OrderComponents(
            accountA,
            zone,
            offer,
            consideration,
            OrderType.FULL_OPEN,
            block.timestamp,
            block.timestamp + 5000,
            _zoneHash,
            _salt,
            nonce
        );
        bytes32 orderHash = consider.getOrderHash(orderComponents);
        bytes32 domainSep = consider.DOMAIN_SEPARATOR();

        bytes32 digest = keccak256(
            abi.encodePacked(bytes2(0x1901), domainSep, orderHash)
        );

        //accountA is pk 1.
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory sig = abi.encodePacked(r, s, v);

<<<<<<< HEAD
        //list
        vm.prank(accountA);
        BasicOrderParameters memory order = BasicOrderParameters(
            address(0),
            0,
            _ethAmount,
            payable(accountA),
            address(0),
            test721Address,
            _id,
            1,
            BasicOrderType.ETH_TO_ERC721_FULL_OPEN,
            block.timestamp,
            block.timestamp + 5000,
            _zoneHash,
            _salt,
            false,
            0,
            new AdditionalRecipient[](0),
            sig
=======
        address considerationToken = address(0); // eth
        uint256 considerationIdentifier = 0; //TODO check on this
        uint256 considerationAmount = _ethAmount;
        address payable offerer = payable(accountA);
        address zone = accountB;
        address offerToken = test721Address;
        uint256 offerIdentifier = _id;
        uint256 offerAmount = 1;
        BasicOrderType basicOrderType = BasicOrderType.ETH_TO_ERC721_FULL_OPEN; // eth to 721 open
        uint256 startTime = block.timestamp; // 0x144
        uint256 endTime = block.timestamp + 5000; // 0x164
        bytes32 zoneHash = _zoneHash; // 0x184
        uint256 salt = _salt; // 0x1a4
        bool useFulfillerProxy = false; // 0x1c4
        uint256 totalOriginalAdditionalRecipients = 0; // 0x1e4
        AdditionalRecipient[]
        memory additionalRecipients = new AdditionalRecipient[](0); // 0x204
        bytes memory signature = sig; // 0x224
        // Total length, excluding dynamic array data: 0x244 (580)

        //list
        vm.prank(accountA);
        BasicOrderParameters memory order = BasicOrderParameters(
            considerationToken,
            considerationIdentifier,
            considerationAmount,
            offerer,
            zone,
            offerToken,
            offerIdentifier,
            offerAmount,
            basicOrderType,
            startTime,
            endTime,
            zoneHash,
            salt,
            useFulfillerProxy,
            totalOriginalAdditionalRecipients,
            additionalRecipients,
            signature
>>>>>>> 3375975e6a8f661b63852f7b4cfa8797a171bed5
        );

        consider.fulfillBasicOrder(order);
        emit log("Consideration basic order made for AccountA");

        //fulfill
        vm.prank(accountB);
    }

    //eth to 1155
    //20 to 721
    //20 to 1155
    //721 to 20
    // 1155 to 20

    //match
    function testMatchOrder721toEth() external {
        emit log("Basic Order, Match Order");
        address seller = accountA;
        vm.startPrank(seller);
    }
}