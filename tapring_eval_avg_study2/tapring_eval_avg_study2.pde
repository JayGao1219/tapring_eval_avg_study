import java.util.*;
import java.math.*;
import javax.swing.*;
import java.io.*;

PFont f;                           // STEP 1 Declare PFont variable
int startTime, endTime;
int pressed=0;
int pressed_prev=0;
PrintWriter output, csv_re;
int counter;

int cw_pos[][]={{195,835,1475},{195,835,1475,195,835,1475},{195,835,1475,195,835,1475,195,835,1475},{115,595,1075,1555,115,595,1075,1555,115,595,1075,1555},{67,451,835,1219,1603,67,451,835,1219,1603,67,451,835,1219,1603},{0,0,0,26,26,26,26,26,418,418,418,418,418,809,809,809,809,809}};
int ch_pos[][]={{418,418,418},{118,118,118,718,718,718},{26,26,26,418,418,418,809,809,809},{26,26,26,26,418,418,418,418,809,809,809,809},{26,26,26,26,26,418,418,418,418,418,809,809,809,809,809},{0,0,0,26,26,26,26,26,418,418,418,418,418,809,809,809,809,809}};
int t[]={1,2,3,4,5,6,7,8,9,10,11,12,13,14, 15, 16, 17};
int tn[] = {3,6,9,12,15, 18};
int win[] = {2000, 3000, 4000, 5000, 6000, 7000};
double TH[] = {0.7, 0.6, 0.5, 0.4, 0.3, 0.3};
ArrayDeque<Double> y = new ArrayDeque<Double>();
ArrayDeque<Double> temp = new ArrayDeque<Double>();
ArrayList<Double> period_cal = new ArrayList<Double>();

ArrayList<ArrayList<Double>> kde_freqs = new ArrayList<ArrayList<Double>>();
ArrayList<ArrayList<Double>> kde_delays = new ArrayList<ArrayList<Double>>();
ArrayList<ArrayList<Integer>> delays_measured = new ArrayList<ArrayList<Integer>>();

double s=0;
int periods_init[][] = {{300, 450, 650}, {300, 350, 400, 500, 600, 700}, {300, 350, 400, 450, 500, 600, 600, 700, 700},
	{300, 350, 400, 400, 450, 450, 500, 500, 600, 600, 700, 700}, {300, 350, 350, 400, 400, 450, 450, 500, 500, 550, 550, 600, 600,700,700}, {300, 350, 350, 400, 400, 450, 450, 500, 500, 550, 550, 600, 600, 650, 650, 650, 700,700}};
int periods[][] = {{300, 450, 650}, {300, 350, 400, 500, 600, 700}, {300, 350, 400, 450, 500, 600, 600, 700, 700},
	{300, 350, 400, 400, 450, 450, 500, 500, 600, 600, 700, 700}, {300, 350, 350, 400, 400, 450, 450, 500, 500, 550, 550, 600, 600,700,700}, {300, 350, 350, 400, 400, 450, 450, 500, 500, 550, 550, 600, 600, 650, 650, 650, 700,700}};
int delays_init[][] = {{0,0,0}, {0,0,0,0,0,0}, {0,0,0,0,0,0,396,0,433},
	{0,0,0,200,0,225,0,320,0,396,0,433},{0,0,175,0,200,0,225,0,320,0,362,0,396,0,433},{0,0,175,0,200,0,225,0,320,0,362,0,396,0,198,396,0,433}};
int delays[][] = {{0,0,0}, {0,0,0,0,0,0}, {0,0,0,0,0,0,396,0,433},
  {0,0,0,200,0,225,0,320,0,396,0,433},{0,0,175,0,200,0,225,0,320,0,362,0,396,0,433},{0,0,175,0,200,0,225,0,320,0,362,0,396,0,198,396,0,433}};
int time_prev[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0};
int status[]={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1, -1, -1};
ArrayList<ArrayDeque<Double>> xs;

int ctime;

int pause_time = 0;
int[] d_DF = {0,0};
double d_thresh = 0.01;
color grey_cover = color(50, 125);
color red_cover = color(255, 0, 0, 125);
double pcal = 0;
int ptime_prev = 0;
Table freq_table;
Table delay_table;
String[] freq_names = {"0","1","2","3","4","5","6","7","8"};
int sign = 1;
int win_freqcal = 2;
double ctime_prev = 0;
double freq_measure = 0;
int freq_baye = 0;
double p_freq = 0;
double p_delay = 0;
int tap_changed = 0;
int tap_time = 0;
int delay_measured = 1000;
int index_freq = -1;
int index_delay = 0;
int index_est = -1;
int cnt_csv = 0;
int session_time = 20000;
int session_starttime = 0;
int staptime = 0;
int stap_flag = 0;

String name[]={"./photo/0.jpeg","./photo/1.jpeg","./photo/2.jpeg","./photo/3.jpeg","./photo/4.jpeg","./photo/5.jpeg","./photo/6.jpeg","./photo/7.jpeg","./photo/8.jpeg","./photo/9.jpeg","./photo/10.jpeg","./photo/11.jpeg","./photo/12.jpeg","./photo/13.jpeg","./photo/14.jpeg","./photo/15.jpeg","./photo/16.jpeg","./photo/17.jpeg"};
int state=0;
String result="";
int nums=0;
boolean finish=false;
PImage imgs;
PImage[] photots=new PImage[18];
int[] w={0,0,0,0,0,0};
int[] h={0,0,0,0,0,0};

void setup() {
	fullScreen();
	f = createFont("Arial",16,true); // STEP 2 Create Font
	textFont(f,30);                            // STEP 3 Specify font to be used
	fill(255,255,255);                         // STEP 4 Specify font color
	colorMode(HSB);
	randomSeed(0);
	pause_time = millis();
	staptime = 0;
	pause_time = 0;
	imgs=loadImage("./photo/bg.jpg");
	imgs.resize(width,height);
	background(imgs);
	for(int i=0;i<18;i++){
		photots[i]=loadImage(name[i]);
	}
	initsize();
}

void getad(int[] array){
	int whole=array[0];
	int n=array[1];
	int ww=array[2];
	int a=0,d=0;
	d=whole/n;
	a=d/2-ww/2;
	array[0]=a;
	array[1]=d;
}

int[] m={1,1,3,2,3,3};
int[] n={3,6,3,6,5,6};

void initsize(){
	h[0]=height/2;
	w[0]=h[0]*25/36;
	h[1]=height/2*2/3;
	w[1]=h[1]/36*25;
	h[2]=height/3*3/3*9/10;
	w[2]=h[2]*25/36;
	h[3]=h[1];
	w[3]=w[1];
	h[4]=h[2];
	w[4]=w[2];
	h[5]=h[2];
	w[5]=w[2];
	/*
	h[3]=h[2];
	h[4]=h[2];
	w[3]=w[2];
	w[4]=w[2];
	w[5]= w[2];
	h[5] = h[2];
	*/
	for(int i=0;i<m.length;++i){
		int[][] cur={{4*width/5,n[i],w[i]},{height,m[i],h[i]}};
		getad(cur[0]);
		getad(cur[1]);
		for(int j=0;j<m[i];++j){
			for(int k=0;k<n[i];++k){
				cw_pos[i][j*n[i]+k]=cur[0][0]+k*cur[0][1]+width/10;
				ch_pos[i][j*n[i]+k]=cur[1][0]+j*cur[1][1];
			}
		}
	}
}

void shuffleArray(int[] array) {
	Random rng = new Random();
	// i is the number of items remaining to be shuffled.
	for (int i = array.length; i > 1; i--) {
		// Pick a random element to swap with the i-th element.
		int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)

		// Swap array elements.
		int tmp = array[j];
		array[j] = array[i-1];
		array[i-1] = tmp;
	}
}

void read_csv(String s, Table table, int[] freqs, ArrayList<ArrayList<Double>> kdes){
	table = loadTable(s, "header");
	kdes.clear();
	for (int freq : freqs){
		ArrayList<Double> kde = new ArrayList<Double>();
		for (TableRow row : table.rows()){
			kde.add(row.getDouble(str(freq)));
		}
		kdes.add(kde);
	}
}

double mean(ArrayList <Double> marks) {
	double sum = 0.0;
	if(!marks.isEmpty()) {
		for (Double mark : marks) {
			sum += mark;
		}
		return sum/ marks.size();
	}
	return sum;
}

//calculate median
public double getMedian(double[] values){
	Median median = new Median();
	double medianValue = median.evaluate(values);
	return medianValue;
}

double freq_meas(double freq){
	// estimate the tapping freq
	int ptime = 0;
	tap_changed = 1;
	//ptime = millis();
	//tap_time = ptime;
	if (period_cal.size() > 1){
		pcal = ((ctime-ptime_prev) + period_cal.get(period_cal.size()-1))/2;
	}
	else{
		pcal = ctime-ptime_prev;
	}
	period_cal.add(pcal);
	freq = pcal;
	//if(ptime-first_press_time > win[nums/3-1]){
	//	freq = getMedian(ArrayUtils.toPrimitive(period_cal.toArray(new Double[period_cal.size()])));
	//	period_cal.remove(0);
	//}
	ptime_prev = ctime;
	return freq;
}

double[] freq_bayesian(double freq_m){
	int index = (int)freq_m - 200;
	if (index >=0 && index <700){
		double p = 0;
		double p_max = 0;
		double p_sum = 0;
		int i_max = 0;
		double[] ps = new double[nums];
		for (int i=0; i<kde_freqs.size(); i++){
			p = kde_freqs.get(i).get(index);
			ps[i] = p;
			p_sum = p_sum + p;
			if (p > p_max){
				p_max = p;
				i_max = i;
			}
		}
		double[] psa = new double[nums];
		for (int i=0; i<nums; i++) {
			psa[i] = ps[i]/p_sum;
		}
		index_freq = i_max;
		return psa;
	}
	else{
		return null;
	}
}

double[] delay_bayesian(ArrayList<Integer> delays_m){
	double p = 0;
	double p_max = 0;
	double p_sum = 0;
	int i_max = 0;
	int current = nums/3-1;
	double[] psa = new double[kde_delays.size()];

	for (int i=0; i<kde_delays.size(); i++){
		//if (periods[current][i] == periods[current][index_freq]){
		int dindex = delays_m.get(i) + 400;
		if (dindex >=0 && dindex <800){
			p = kde_delays.get(i).get(dindex);
		}
		//ps.add(p);
		psa[i] = p;
		//	p_sum = p_sum + p;
		//	if (p > p_max){
		//		p_max = p;
		//		i_max = i;
		//	}
		////}
	}

	//double[] psa = new double[ps.size()];
	//for (int i=0; i<ps.size(); i++) {
	//	psa[i] = ps.get(i);
	//}
	//index_delay = i_max;
	return psa;
}

double get_delay_bayesian(int findex, int delay_m){
	int index = delay_m + 400;
	double p = 0;
	if (index >= 0 && index <800){
		p = kde_delays.get(findex).get(index);
	}
	return p;
}

int item_est (double[] ps_freq, double[] ps_delay){
	int index = -1;
	double p_max = 0;
	double[] ps_total = new double[ps_freq.length];
	for (int i=0; i<ps_total.length;i++){
		double p_total = ps_freq[i] * ps_delay[i];
		if (p_max < p_total){
			p_max = p_total;
			index = i;
		}
	}
	return index;
}

boolean init = true;
int sstarttime = 0;
int inittime = 0;
int start_session_flag = 0;
int target_i = 0;
int first_press_time = 0;
int first_flag = 0;
int[] t_block;
ArrayList<double[]> ps_bayesian_win = new ArrayList<double[]>();

void draw() {
	background(imgs);
	//display press status
	switch(state){
		case 0:
			text("Please input your student ID\n"+result,133,133);
			break;
		case 1:
			state++;

			output = createWriter("./human/"+result+"/"+result+"_"+session+"_"+block+"_"+nums+".csv");
			output.write("timestamp,pressed");
			for(int i=0; i<nums;i++){
				output.write(",pattern"+str(i));
			}
			output.println();
			shuffleArray(t);
			t_block = new int[nums];
			t_block[0] = 0;
			for(int i=0;i<nums-1;i++){
				t_block[i] = t[i];
			}
			shuffleArray(t_block);
			inittime = millis();
			break;
		case 2:
			if(session != 0 && block == 0){
        if(session%5==0){
                  if(millis() - inittime < 30000){
          start_session_flag = 0;
          textSize(100);
          text("Session "+ nf(session)+" can be started in "+ nf(180-(millis()-inittime)/1000)+" seconds.", 666, 666);
        }
        else{
          text("Session "+ nf(session)+" can be started in 0 seconds.", 666, 666);
          text("Press ENTER to start", 666, 866);
          start_session_flag = 1;
        }
        }
        else{
				if(millis() - inittime < 15000){
					start_session_flag = 0;
					textSize(100);
					text("Session "+ nf(session)+" can be started in "+ nf(60-(millis()-inittime)/1000)+" seconds.", 666, 666);
				}
				else{
					text("Session "+ nf(session)+" can be started in 0 seconds.", 666, 666);
					text("Press ENTER to start", 666, 866);
					start_session_flag = 1;
				}
        }
			}
			else{
				state++;
			}
			break;
		case 3:
			int current=nums/3-1;
			// init for current task
			if(init){
				textSize(16);
				sstarttime = millis();
				for(int i=0;i<nums;i++){
					time_prev[i] = sstarttime;
					delays[current][i] = delays_init[current][i];
					status[i] = 1;
					if(t_block[i] == 0){
						target_i = i;
					}
				}
				period_cal.clear();
				ps_bayesian_win.clear();
				index_est = -1;
				index_freq = -1;
				tap_changed = 0;
				pressed_prev = pressed;
				ptime_prev = sstarttime;
				freq_measure = 0;
				delays_measured.clear();
				read_csv("freq_allstudy1.csv", freq_table, periods[current],kde_freqs);
				read_csv("delay_allstudy1.csv", delay_table, periods[current],kde_delays);
				init = false;
        finish=false;
				first_flag = 0;
				for(int i=0;i<18;++i)
					photots[i].resize(w[current],h[current]);
				printArray(tn);
			}
			ctime = millis();
			// draw the pictures and blinking dot
			for(int i=0;i<nums;i++){
				image(photots[t_block[i]],cw_pos[current][i],ch_pos[current][i]);
				if (ctime - delays[current][i] - time_prev[i]> periods[current][i]){
					time_prev[i] = ctime;
					delays[current][i] = 0;
					status[i] = -status[i];
				}
				if (status[i]==1){
					fill(#ff0000);
					noStroke();
					rect(cw_pos[current][i]+w[current]-40, ch_pos[current][i],40,40);
				}
			}

			// calculate bayesian probability for each tap
			if (pressed != pressed_prev && first_flag != 0) {
        pressed_prev = pressed;
				// measure period and calcualte freq bayesian probability
				freq_measure = freq_meas(freq_measure);
				double[] ps_freq = freq_bayesian(freq_measure);
				// measure delay for all blinking patterns
				ArrayList<Integer> delays_m = new ArrayList<Integer>();
				for (int i=0; i<nums; i++){
					int d_taplead = ctime - time_prev[i];
					int d_patternlead = ctime - (time_prev[i] + periods[current][i]);
					if (abs(d_taplead) < abs(d_patternlead)){
						delay_measured = d_taplead;
					}
					else{
						delay_measured = d_patternlead;
					}
					delays_m.add(delay_measured);
				}
				//delays_measured.add(delays_m);
				//printArray(delays_m);

				//calculate delay bayesian P
				if(ps_freq != null){
					// printArray(ps_freq);
					double[] pdelays = delay_bayesian(delays_m);
					ArrayList<Integer> cnts = new ArrayList<Integer>();
					ArrayList<Double> sums = new ArrayList<Double>();
					cnts.add(0);
					double p_sum = pdelays[0];
					for (int i=1; i<nums; i++){
						if (periods[current][i] != periods[current][i-1]){
							cnts.add(i);
							sums.add(p_sum);
							p_sum = pdelays[i];
						}
						else{
							p_sum = p_sum + pdelays[i];
						}
					}
					//add the sum item for the last cnt item
					sums.add(p_sum);
					cnts.add(pdelays.length);

					// use delay arrays for Bayesian estimation
					double[] ps_bayesian = new double[nums];
					for (int i=0; i<cnts.size()-1; i++){
						for (int j=cnts.get(i); j<cnts.get(i+1); j++){
							ps_bayesian[j] = ps_freq[j]* pdelays[j]/sums.get(i);
						}
					}
					ps_bayesian_win.add(ps_bayesian);
          
					if(ctime - first_press_time > win[current]){
						ps_bayesian_win.remove(0); 
						double[] ps_bayesian_win_mean = new double[nums];
						double pmax = 0;
						for (int j = 0; j < ps_bayesian_win_mean.length; j++){
							for (int i = 0; i < ps_bayesian_win.size(); i++){
								ps_bayesian_win_mean[j] =  ps_bayesian_win_mean[j]+ps_bayesian_win.get(i)[j];
							}
							ps_bayesian_win_mean[j] =  ps_bayesian_win_mean[j]/ps_bayesian_win.size();
							if (ps_bayesian_win_mean[j] > pmax){
								pmax = ps_bayesian_win_mean[j];
								index_est = j;
							}
						}
						//printArray(ps_bayesian_win_mean);
					}
					//double pssum = 0;
					//for (int k=0; k<ps_bayesian.length; k++){
					//  pssum = pssum + ps_bayesian[k];
					//}
				}
			}

			text("session #"+nf(session)+"   block#"+nf(block),100,20);

			if (pressed == 1 && first_flag == 0){
				first_press_time = ctime;
				first_flag = 1;
			}

			if(index_est > -1 ){
				strokeWeight(10.0);
				stroke(#91eae4);
				noFill();
				rect(cw_pos[current][index_est], ch_pos[current][index_est], w[current], h[current]);
				finish=true;

			}
			if(ctime-sstarttime > 20000){
				finish=true;
				println("TIMEOUT");
			}

			if(finish == true){
				println("finish  ,"+str(ctime-sstarttime));
				output.flush();
				output.close();
        csv_re.print(result+','+str(session)+','+str(block)+','+str(nums)+','+str(target_i)+','+str(index_est)+','+str(ctime-sstarttime)+','+str(ctime-first_press_time));
        csv_re.println();
        println(result+','+str(session)+','+str(block)+','+str(nums)+','+str(target_i)+','+str(index_est)+','+str(ctime-sstarttime));
				noLoop();
			}

			//write current blinking status to CSV
			output.print(str(millis())+','+str(pressed));
			for(int i=0;i<nums;i++){
				output.print(','+str(status[i]));
			}
			output.println();
			break;
	}
}

color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

void getRect(float ss,int p1,int p2){
	noFill();
	if(ss<0.5){
		stroke(lerpColor(#1E9600, #FFF200, ss));
	}
	else{
		stroke(lerpColor(#FFF200, #FF0000, ss));
	}
	strokeWeight(10);
	arc(p1,p2,115,115,0.0,TWO_PI*ss);
}

int block = 0;
int session = 0;
void keyPressed(){
	if(state==3){
		if(!finish){
			if (key == ' '){
				pressed = 1;
			}
		}
		else{
			if(key==ENTER){
				if(block < 5) {
					block = block + 1;
					nums = tn[block];
					finish=false;
					state=1;
					init = true;
				}
				else{
					println("SESSION COMPLETE!!!");
					block = 0;
					session = session + 1;
					shuffleArray(tn);
					nums = tn[block];
					finish=false;
					state=1;
					init = true;  
          //csv_re.flush();
				}
				loop();
			}
		}
	}
	else if(state==0){
		if(key==ENTER||key==RETURN){
			if(result!=""){
				state=1;
				shuffleArray(tn);
				if(block < 6) {
					nums = tn[block];
					finish=false;
					state=1;
					init = true;
				}
				File file=null;
				try{
					file=new File("./human/"+result);
					file.mkdirs();
				}
				catch(Exception e){
				}
				finally{
					file=null;
          csv_re = createWriter("./human/"+result+"/"+result+".csv");
          csv_re.write("user,session,block,nums,target_i,index_est,ctime,ttime");
          csv_re.println();
				}
			}
		}
		else
			result=result+key;
	}
	else if (state == 2){
		if(key==ENTER||key==RETURN){
			if(start_session_flag == 1){
				state = state + 1;
			}
		}
	}
  if (key==ESC){
    exit();
  }
}


void keyReleased(){
	if (key == ' '){
		pressed = 0;
		endTime = millis();
	}
	//if (key >= '1' && key <= '9'){
	//	loop();
	//	cnt_csv = (int)key-48-1;
	//	csv_write_routine(cnt_csv);
	//	session_starttime = millis();
	//	pause_time = millis();
	//	//clean();
	//}
	//if (key == 'e'){
	//	exit();
	//}
}

void clean(){
	int current = nums/3-1;
	period_cal.clear();
	pcal = 0;
	period_cal.add(pcal);
	index_est = -1;
	index_freq = -1;
	tap_changed = 0;
	pressed_prev = 0;
	freq_measure = 0;
	stap_flag = 0;
	for(int i =0;i<nums;i++){
		time_prev[i] = 0;
		delays[current][i] = delays_init[current][i];
		status[i] = 1;
	}
	delays_measured.clear();
}

float max_float(float x[]){
	float max_value=0;
	int index = 0;
	for(int i=0;i<x.length;i++){
		if (x[i] > max_value){
			max_value = x[i];
			index = i;
		}
	}
	return max_value;
}

double max_float(double x[]){
	double max_value=0;
	int index = 0;
	for(int i=0;i<x.length;i++){
		if (x[i] > max_value){
			max_value = x[i];
			index = i;
		}
	}
	return max_value;
}

float max_diff(float x[]){
	float max_value=0;
	float diff = 0;
	for(int i=0;i<x.length;i++){
		if (x[i] > max_value){
			diff = x[i] - max_value;
			max_value = x[i];
		}
	}
	return diff;
}

int max_index(float x[]){
	float max_value=0.0f;
	int index = 0;
	for(int i=0;i<x.length;i++){
		if (x[i] > max_value){
			max_value = x[i];
			index = i;
		}
	}
	return index;
}

int get_nearest(int x[], double target){
	double min_value = 1000;
	int index = -1;
	for(int i=0;i<x.length;i++){
		if (abs((float)(x[i]-target)) < min_value){
			min_value = abs((float)(x[i]-target));
			index = i;
		}
	}
	return index;
}

void exit(){
	output.flush();
	output.close();
	csv_re.flush();
	csv_re.close();
	super.exit();
}
