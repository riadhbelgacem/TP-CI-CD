package application;

public class Calcul {
	public int sommme(int a,int b) {
		return a+b;
	}
	public int division(int x,int y) {
		if(y==0) {
			throw new ArithmeticException();
		}
		return x/y;
	}

}
