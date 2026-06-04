// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CorporateTreasury {
    error CorporateTreasury__NotAuthorized();

    error CorporateTreasury__InvalidAmount();

    error CorporateTreasury__SelectContinent();

    error CorporateTreasury__IDExists();

    error CorporateTreasury__InvestmentDoesNotExist();

    enum Continent {
        None,
        NorthAmerica,
        Europe,
        Asia,
        Oceania,
        SouthAmerica,
        Africa
    }

    enum AssetClass {
        Equity,
        FixedIncome,
        Crypto,
        RealEstate
    }

    struct Investment {
        uint256 id;
        address investor;
        string assetName;
        uint256 principal;
        uint256 timestamp;
        Continent continent;
        AssetClass assetClass;
    }

    mapping(uint256 => Investment) public ledger;

    mapping(uint256 => bool) public idUsed;

    uint256 public totalInvestmentsCount;

    address public immutable owner;

    event InvestmentRecorded(
        uint256 id,
        address investor,
        string assetName,
        uint256 principal,
        Continent continent
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert CorporateTreasury__NotAuthorized();
        }
        _;
    }

    function addInvestment(
        uint256 _id,
        string memory _assetName,
        Continent _continent,
        AssetClass _assetClass
    ) external payable {
        if (msg.value == 0) {
            revert CorporateTreasury__InvalidAmount();
        }

        if (_continent == Continent.None) {
            revert CorporateTreasury__SelectContinent();
        }

        if (idUsed[_id]) {
            revert CorporateTreasury__IDExists();
        }

        ledger[_id] = Investment({
            id: _id,
            investor: msg.sender,
            assetName: _assetName,
            principal: msg.value,
            timestamp: block.timestamp,
            continent: _continent,
            assetClass: _assetClass
        });

        idUsed[_id] = true;

        totalInvestmentsCount++;

        emit InvestmentRecorded(
            _id,
            msg.sender,
            _assetName,
            msg.value,
            _continent
        );
    }

    function getDaysUnderManagement(
        uint256 _id
    ) public view returns (uint256 daysUnderMgmt) {
        if (!idUsed[_id]) {
            revert CorporateTreasury__InvestmentDoesNotExist();
        }

        Investment memory investment = ledger[_id];

        daysUnderMgmt = (block.timestamp - investment.timestamp) / 1 days;
    }

    function calculateYield(
        uint256 _id
    ) public view returns (uint256 accruedYield) {
        if (!idUsed[_id]) {
            revert CorporateTreasury__InvestmentDoesNotExist();
        }

        uint256 daysActive = getDaysUnderManagement(_id);

        if (daysActive == 0) {
            return 0;
        }

        Investment memory investment = ledger[_id];

        accruedYield = (investment.principal * 5 * daysActive) / 36500;
    }

    function getInvestmentSummary(
        uint256 _id
    )
        external
        view
        returns (address investor, uint256 principal, Continent continent)
    {
        if (!idUsed[_id]) {
            revert CorporateTreasury__InvestmentDoesNotExist();
        }

        Investment memory investment = ledger[_id];

        return (
            investment.investor,
            investment.principal,
            investment.continent
        );
    }
}
