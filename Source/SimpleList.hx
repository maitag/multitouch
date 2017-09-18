package;

/**
 * simple linked list
 * 
 * @author Sylvio Sell
 */

class SimpleList<T>
{
	public var first:SimpleListNode<T>;
	public var last:SimpleListNode<T>;
	
	public var length:Int = 0;
	
	var n:SimpleListNode<T>;
	
	public function new()
	{
		first = null;
	}
	
	inline public function prepend(newnode:T):SimpleListNode<T>
	{
		length++;
		n = new SimpleListNode<T>(newnode, this);
		n.next = first;
		if (first != null) first.prev = n;
		first = n;
		if (length == 1) last = n;
		return n;
	}
	
	inline public function append(newnode:T):SimpleListNode<T>
	{
		length++;
		n = new SimpleListNode<T>(newnode, this);
		n.prev = last;
		if (last != null) last.next = n;
		last = n;
		if (length == 1) first = n;
		return n;
	}
	

	inline public function unlink(node:SimpleListNode<T>):SimpleListNode<T>
	{
		length--;
		if (node == first)
		{
			if (node.next != null)
			{
				first = node.next;
				node.next.prev = null;
			}
			else first = last = null;
		}
		else
		{
			if (node.next != null)
			{
				node.prev.next = node.next;
				node.next.prev = node.prev;
			}
			else {
				node.prev.next = null; // last
				last = node.prev;
			}
		}
		return node.next;
	}

}