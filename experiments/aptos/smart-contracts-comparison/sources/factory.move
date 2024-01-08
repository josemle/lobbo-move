/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Product{
    string tag;
    address owner;
    address factory;

    constructor(string memory _tag){
        owner = tx.origin;
        factory = msg.sender;
        tag = _tag;
    }

    function getTag() public view returns(string memory){
        require(msg.sender == owner, "only the owner");
        return tag;
    }

    function getFactory() public view returns(address){
        return factory;
    }
}

contract Factory{
    mapping (address => address[]) productList;
    function createProduct(string memory _tag) public returns(address) {
        Product p = new Product(_tag);
        productList[msg.sender].push(address(p));
        return address(p);
    }

    function getProducts() public view returns(address[] memory){
        return productList[msg.sender];
    }
}
*/
/*

module deploy_address::product {

    friend deploy_address::factory;

    struct Product has key {
        tag: vector<u8>,
        owner: address,
    }

    public(friend) fun create_product(tag: vector<u8>): Product {
        let product = Product{
            tag: tag,
            owner: signer_address(),
        };
        product
    }

    public fun get_tag(product: &Product): vector<u8> {
        product.tag
    }
}

module deploy_address::factory {
    use deploy_address::product::{Self, Product};

    struct Factory has key {
        products: vector<Product>,
    }

    public fun create_factory(): Factory {
        let factory = Factory{
            products: {},
        };
        factory
    }

    public fun create_product(factory: &Factory, tag: vector<u8>) {
        let product = product::create_product(tag);
        vector::push(&mut factory.products, product);
    }

    public fun get_products(factory: &Factory) {}
}
*/