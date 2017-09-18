package;

/**
 * simple linked list node
 * 
 * @author Sylvio Sell
 */

class SimpleListNode<T>
{
	public var node:T;
	public var next:SimpleListNode<T>;
	public var prev:SimpleListNode<T>;
	public var dll:SimpleList<T>;

	inline public function new(newnode:T, list:SimpleList<T>)
	{
		node = newnode;
		dll = list;
	}

}