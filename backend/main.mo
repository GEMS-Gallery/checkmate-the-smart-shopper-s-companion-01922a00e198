import Bool "mo:base/Bool";
import Func "mo:base/Func";
import List "mo:base/List";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the structure for a shopping list item
  type ShoppingItem = {
    id: Nat;
    name: Text;
    completed: Bool;
  };

  // Initialize a stable variable to store the shopping list
  stable var shoppingList: [ShoppingItem] = [];
  stable var nextId: Nat = 0;

  // Function to add a new item to the shopping list
  public func addItem(name: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: ShoppingItem = {
      id;
      name;
      completed = false;
    };
    shoppingList := Array.append(shoppingList, [newItem]);
    id
  };

  // Function to toggle the completion status of an item
  public func toggleItem(id: Nat) : async Bool {
    let index = Array.indexOf<ShoppingItem>({ id; name = ""; completed = false }, shoppingList, func(a, b) { a.id == b.id });
    switch (index) {
      case null { false };
      case (?i) {
        let item = shoppingList[i];
        let updatedItem = {
          id = item.id;
          name = item.name;
          completed = not item.completed;
        };
        shoppingList := Array.tabulate(shoppingList.size(), func (j: Nat) : ShoppingItem {
          if (j == i) { updatedItem } else { shoppingList[j] }
        });
        true
      };
    }
  };

  // Function to delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let newList = Array.filter(shoppingList, func(item: ShoppingItem) : Bool { item.id != id });
    if (newList.size() < shoppingList.size()) {
      shoppingList := newList;
      true
    } else {
      false
    }
  };

  // Function to get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    shoppingList
  };
}
