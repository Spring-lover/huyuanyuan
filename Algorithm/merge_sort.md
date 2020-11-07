```java
public void merge_sort(int[] arr, int l, int r){
    if(l >= r) return ;

    int mid = l + (r - l) / 2;
    merge_sort(arr, l, mid);
    merge_sort(arr, mid + 1, r);

    int tmp = new int [r - l + 1];

    int i = l, j = mid, k = 0;

    while(i <= mid && j <= r){
        if(arr[i] <= arr[j]) tmp[k++] = arr[i++];
        else tmp[k++] = arr[j++];
    }
    while(i <= mid) {
        tmp[k++] = arr[i++];
    }
    while(j <= mid){
        tmp[k++] = arr[j++];
    }

    for(i = l, j = 0; i <= r; i ++, j++){
        arr[i] = tmp[j];
    }
}
```